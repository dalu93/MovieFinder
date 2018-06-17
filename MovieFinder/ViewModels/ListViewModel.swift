//
//  ListViewModel.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - ListViewModel declaration
final class ListViewModel<APIService: APIConnectable> {

    struct State {
        var items: [ListItem]
        var isNextPageAvailable: Bool
        var connectionStatus: ConnectionStatus<APIService.RequestType, Void>
    }

    // MARK: - Properties
    // MARK: Private properties
    private let _apiService: APIService
    private let _keyword: String

    // Search results will be stored in order here.
    private var _searchResults: [SearchResult]
    private var _currentPage: Int = 1

    // MARK: Public properties
    var usedKeyword: String {
        return _keyword
    }

    private(set) var state: Bindable<State> = Bindable(
        State(
            items: [],
            isNextPageAvailable: true,
            connectionStatus: .notStarted
        )
    )

    private var _isNextPageAvailable: Bool {
        return _searchResults.first!.totalPages > _currentPage
    }

    private var _items: [ListItem] {
        return _searchResults.reduce([]) {
            return $0 + $1.results.map { movie in
                let item = movie.listItem
                guard let imagePath = movie.posterPath else {
                    return item
                }

                let thubmnailUrl =
                    self._apiService.imageUrlProvider.imageUrlUsing(imagePath)

                return ListItem(
                    title: item.title,
                    thubmnailUrl: thubmnailUrl,
                    description: item.description,
                    subtitle: item.subtitle
                )
            }
        }
    }

    // MARK: - Object lifecycle
    init(
        service: APIService,
        keyword: String,
        searchResult: SearchResult
    ) {
        _apiService = service
        _keyword = keyword
        _searchResults = [searchResult]
        state = Bindable(
            State(
                items: _items,
                isNextPageAvailable: _isNextPageAvailable,
                connectionStatus: .notStarted
            )
        )
    }

    func loadNextPage() {
        guard state.value.isNextPageAvailable else { return }
        guard state.value.connectionStatus.isInProgress == false else { return }

        // Avoid to download the same page
        let newPageToDownload = _currentPage + 1
        let isDownloaded = _searchResults.contains(where: {
            $0.page == newPageToDownload
        })

        guard isDownloaded == false else { return }

        let request = SearchResult.get(
            with: _keyword,
            at: newPageToDownload,
            using: _apiService
        ) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let result):
                if self._searchResults.contains(result) == false {
                    self._searchResults.append(result)
                }

                self._currentPage += 1
                self.state.value = State(
                    items: self._items,
                    isNextPageAvailable: self._isNextPageAvailable,
                    connectionStatus: .completed(.success(()))
                )

            case .failed(let error):
                self.state.value = State(
                    items: self._items,
                    isNextPageAvailable: self._isNextPageAvailable,
                    connectionStatus: .completed(.failed(error))
                )
            }
        }

        state.value = State(
            items: _items,
            isNextPageAvailable: _isNextPageAvailable,
            connectionStatus: .inProgress(request)
        )
    }
}
