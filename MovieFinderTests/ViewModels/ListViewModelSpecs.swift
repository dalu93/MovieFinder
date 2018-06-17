//
//  ListViewModelSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/17/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MovieFinder

final class ListViewModelSpecs: QuickSpec {
    override func spec() {
        let apiService = APIServiceMock()

        context("[UT] when loading the next page") {
            describe("if the page is not available") {
                it("should not change the state") {
                    // GIVEN
                    let initialSearchResult = SearchResult(
                        page: 1,
                        totalResults: 0,
                        totalPages: 1,
                        results: []
                    )

                    let viewModel = ListViewModel<APIServiceMock>(
                        service: apiService,
                        keyword: "assddf",
                        searchResult: initialSearchResult
                    )

                    var didChangeState = false
                    viewModel.state.bind { _ in
                        didChangeState = true
                    }

                    // WHEN
                    viewModel.loadNextPage()

                    // THEN
                    expect(didChangeState).to(beFalse())
                    expect(viewModel.state.value.items).to(beEmpty())
                }
            }

            describe("if the viewModel is already loading") {
                it("should not change the state") {
                    let initialSearchResult = SearchResult(
                        page: 1,
                        totalResults: 21,
                        totalPages: 2,
                        results: []
                    )

                    let viewModel = ListViewModel<APIServiceMock>(
                        service: apiService,
                        keyword: "assddf",
                        searchResult: initialSearchResult
                    )

                    viewModel.state.value = ListViewModel.State(
                        items: [],
                        isNextPageAvailable: true,
                        connectionStatus: .inProgress(())
                    )

                    var didChangeState = false
                    viewModel.state.bind { _ in
                        didChangeState = true
                    }

                    // WHEN
                    viewModel.loadNextPage()

                    // THEN
                    expect(didChangeState).to(beFalse())
                    expect(viewModel.state.value.connectionStatus.isInProgress).to(beTrue())
                }
            }

            describe("if the viewModel already downloaded it") {
                it("should not change the state") {
                    let initialSearchResult = SearchResult(
                        page: 2,
                        totalResults: 21,
                        totalPages: 2,
                        results: []
                    )

                    let viewModel = ListViewModel<APIServiceMock>(
                        service: apiService,
                        keyword: "assddf",
                        searchResult: initialSearchResult
                    )

                    viewModel.state.value = ListViewModel.State(
                        items: [],
                        isNextPageAvailable: true,
                        connectionStatus: .notStarted
                    )

                    var didChangeState = false
                    viewModel.state.bind { _ in
                        didChangeState = true
                    }

                    // WHEN
                    viewModel.loadNextPage()

                    // THEN
                    expect(didChangeState).to(beFalse())
                }
            }

            describe("if the viewModel receives a correct result") {
                it("should change accordingly the state") {
                    let initialSearchResult = SearchResult(
                        page: 1,
                        totalResults: 21,
                        totalPages: 2,
                        results: []
                    )

                    apiService.responseFileName = "search_result_page_2"

                    let viewModel = ListViewModel<APIServiceMock>(
                        service: apiService,
                        keyword: "assddf",
                        searchResult: initialSearchResult
                    )

                    var itemsCount = 0
                    var didChangeState = false
                    viewModel.state.bind { state in
                        didChangeState = true
                        itemsCount = state.items.count
                    }

                    // WHEN
                    viewModel.loadNextPage()

                    // THEN
                    expect(didChangeState).toEventually(beTrue())
                    expect(itemsCount).toEventually(equal(2))
                }
            }

            describe("if the viewModel receives an error") {
                it("should change accordingly the state") {
                    let initialSearchResult = SearchResult(
                        page: 1,
                        totalResults: 21,
                        totalPages: 2,
                        results: []
                    )

                    let expectedError = AppError.List.loadingNextPageFailed
                    apiService.responseFileName = ""
                    apiService.responseError = expectedError

                    let viewModel = ListViewModel<APIServiceMock>(
                        service: apiService,
                        keyword: "assddf",
                        searchResult: initialSearchResult
                    )

                    var actualError: AppError.List?
                    var didChangeState = false
                    viewModel.state.bind { state in
                        didChangeState = true
                        switch state.connectionStatus {
                        case .completed(let result):
                            actualError = result.error as! AppError.List

                        default: break
                        }
                    }

                    // WHEN
                    viewModel.loadNextPage()

                    // THEN
                    expect(didChangeState).toEventually(beTrue())
                    expect(actualError).toEventuallyNot(beNil())
                    expect(actualError).toEventually(equal(expectedError))
                }
            }
        }
    }
}
