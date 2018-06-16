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

    var searchStatus: Bindable<ConnectionStatus<Request, Result>> { get }
    func search(for keyword: String)
}

// MARK: - SearchViewModel declaration
final class SearchViewModel<APIService: APIConnectable>: SearchViewModelType {
    // MARK: - Properties
    // MARK: Public properties
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
        guard _isKeywordValid(keyword) else {
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
            if result.isSuccess {
                self?._save(keyword)
            }
        }

        searchStatus.value = .inProgress(request)
    }

    func showResult(for searchResult: SearchResult) {
        guard searchResult.results.count > 0 else {
            searchStatus.value = .completed(.failed(AppError.Search.noResults))
            return
        }

        _flowController.show(searchResult)
    }

    // MARK: Private methods
    private func _isKeywordValid(_ keyword: String) -> Bool {
        return keyword.count > 0
    }

    private func _save(_ keyword: String) {
        let suggestion = Suggestion(keyword: keyword)
        let entity = suggestion.entity
        do {
            try self._suggestionStore.save(entity)
        } catch {
            log.debug("The suggestion (\"\(entity.keyword)\") couldn't be saved. \(error)")
        }
    }
}
