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

    // MARK: - Object lifecycle
    init(_ service: APIService) {
        _service = service
    }

    // MARK: - Methods
    // MARK: Public methods
    func search(for keyword: String) {
        guard _isKeywordValid(keyword) else {
            searchStatus.value = .completed(.failed(AppError.Search.invalidKeyword))
            return
        }

        let request = SearchResult.get(
            with: keyword,
            at: 1,
            using: _service
        ) { [weak self] result in
            self?.searchStatus.value = .completed(result)
        }

        searchStatus.value = .inProgress(request)
    }

    // MARK: Private methods
    private func _isKeywordValid(_ keyword: String) -> Bool {
        return keyword.count > 0
    }
}
