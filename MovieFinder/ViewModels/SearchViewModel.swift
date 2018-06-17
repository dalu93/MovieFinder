//
//  SearchViewModel.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - SearchViewModelType declaration
protocol SearchViewModelType {
    associatedtype Result
    associatedtype Request
    associatedtype SuggestionType

    var availableSuggestions: [SuggestionType] { get }
    var searchStatus: Bindable<ConnectionStatus<Request, Result>> { get }
    func search(for keyword: String)
}

// MARK: - SearchViewModel declaration
final class SearchViewModel<
    APIService: APIConnectable,
    SuggestionStore: SuggestionStoreType,
    MainFlowController: MainFlowControllerType
>: SearchViewModelType {
    // MARK: - Properties
    // MARK: Public properties
    var availableSuggestions: [Suggestion] {
        do {
            log.debug("Loading suggestions from store")
            return try Array(_suggestionStore.all()
                .map { Suggestion(with: $0) }
                .sorted(by: { $0.createdAt > $1.createdAt })
                .prefix(10))
        } catch {
            log.error("Failed to load suggestions from store. \(error)")
            return []
        }
    }
    private(set) var searchStatus: Bindable<ConnectionStatus<APIService.RequestType, SearchResult>> = Bindable(.notStarted)
    // MARK: Private properties
    fileprivate let _service: APIService
    fileprivate let _flowController: MainFlowController
    fileprivate let _suggestionStore: SuggestionStore

    // MARK: - Object lifecycle
    init(service: APIService, flowController: MainFlowController, suggestionStore: SuggestionStore) {
        _service = service
        _flowController = flowController
        _suggestionStore = suggestionStore
    }

    // MARK: - Methods
    // MARK: Public methods
    func search(for keyword: String) {
        log.debug("Searching for \(keyword)")
        guard _isKeywordValid(keyword) else {
            log.error("The keyword is invalid")
            searchStatus.value = .completed(.failed(AppError.Search.invalidKeyword))
            return
        }

        let page = 1
        let request = SearchResult.get(
            with: keyword,
            at: page,
            using: _service
        ) { [weak self] result in
            self?.searchStatus.value = .completed(result)
            if let searchResult = result.value,
                searchResult.totalResults > 0 {
                log.debug("The result is valid and has more than 0 results. Storing the keyword")
                self?._save(keyword)
            }
        }

        searchStatus.value = .inProgress(request)
    }

    func showResult(for searchResult: SearchResult, keyword: String) {
        guard searchResult.totalResults > 0 else {
            log.error("Cannot show list for 0 results")
            searchStatus.value = .completed(.failed(AppError.Search.noResults))
            return
        }

        log.debug("Showing list for keyword: \(keyword)")
        _flowController.show(searchResult, using: keyword)
    }

    // MARK: Private methods
    private func _isKeywordValid(_ keyword: String) -> Bool {
        return keyword.isEmpty == false
    }

    private func _save(_ keyword: String) {
        let suggestion = Suggestion(
            keyword: keyword,
            createdAt: Date()
        )

        let entity = suggestion.entity
        do {
            try self._suggestionStore.save(entity)
        } catch {
            log.error("The suggestion (\"\(entity.keyword)\") couldn't be saved. \(error)")
        }
    }
}
