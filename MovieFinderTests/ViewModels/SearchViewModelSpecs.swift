//
//  SearchViewModelSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/17/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MovieFinder

final class SearchViewModelSpecs: QuickSpec {
    override func spec() {
        let apiService = APIServiceMock()
        apiService.responseType = .manyResults
        let store = SuggestionStoreMock()
        let flowController = MainFlowControllerMock()
        let viewModel = SearchViewModel<APIServiceMock, SuggestionStoreMock, MainFlowControllerMock>(
            service: apiService,
            flowController: flowController,
            suggestionStore: store
        )

        context("[UT] When searching for keyword") {
            describe("if the keyword is invalid") {
                it("should return invalidKeyword error") {
                    // GIVEN
                    let keyword = ""
                    var actualError: AppError.Search?
                    viewModel.searchStatus.bind { status in
                        switch status {
                        case .completed(let result):
                            if let error = result.error as? AppError.Search {
                                actualError = error
                            }

                        default: break
                        }
                    }

                    // WHEN
                    viewModel.search(for: keyword)

                    // THEN
                    expect(actualError).toEventuallyNot(beNil())
                    expect(actualError).toEventually(equal(AppError.Search.invalidKeyword))
                }
            }

            describe("if the keyword is valid and the results are more than 0") {
                it("should store the keyword") {
                    // GIVEN
                    apiService.responseType = .manyResults
                    let keyword = "aaaaa"
                    var isKeywordStored = false
                    viewModel.searchStatus.bind { status in
                        switch status {
                        case .completed:
                            isKeywordStored = store.saveIsCalled

                        default: break
                        }
                    }

                    // WHEN
                    viewModel.search(for: keyword)

                    // THEN
                    expect(isKeywordStored).toEventually(beTrue())
                }
            }

            xdescribe("if the keyword is valid and the results are 0") {
                it("should not store the keyword") {
                    // GIVEN
                    apiService.responseType = .noResults
                    store.saveIsCalled = false
                    let keyword = "aaaaa"
                    var isKeywordStored = true
                    waitUntil { done in
                        viewModel.searchStatus.bind { status in
                            switch status {
                            case .completed:
                                isKeywordStored = store.saveIsCalled
                                done()

                            default: break
                            }
                        }
                    }

                    // WHEN
                    viewModel.search(for: keyword)

                    // THEN
                    expect(viewModel.searchStatus.value.isInProgress).toEventually(beFalse())
                    expect(isKeywordStored).toEventually(beFalse())
                }
            }
        }

        context("[UT] when showing a search result") {
            describe("if the results are more than 0") {
                it("should call the show(_ result:) method in FlowController") {
                    // GIVEN
                    flowController.isShowCalled = false
                    let searchResult = SearchResult(
                        page: 1,
                        totalResults: 2000,
                        totalPages: 100,
                        results: []
                    )

                    // WHEN
                    viewModel.showResult(for: searchResult, keyword: "some")

                    // THEN
                    expect(flowController.isShowCalled).to(beTrue())
                }
            }
        }
    }
}

private class APIServiceMock: APIConnectable {
    enum ResponseType {
        case noResults
        case manyResults
    }

    struct ImageProvider: ImageUrlProviderType {
        func imageUrlUsing(_ path: String) -> URL? {
            return nil
        }
    }

    let baseAPIURL = ""
    let imageUrlProvider = ImageProvider()
    var responseType: ResponseType = .noResults
    func load<Object>(resource: Resource<Object>, completion: @escaping (Completion<Object>) -> Void) -> Any {
        switch responseType {
        case .noResults:
            let bundle = Bundle(for: type(of: self))
            let url = bundle.url(forResource: "search_result", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let result = try! SearchResult(with: data)
            completion(.success(result as! Object))

        case .manyResults:
            let bundle = Bundle(for: type(of: self))
            let url = bundle.url(forResource: "many_search_results", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let result = try! SearchResult(with: data)
            completion(.success(result as! Object))
        }

        return ()
    }
}

private class SuggestionStoreMock: SuggestionStoreType {
    var saveIsCalled: Bool = false
    func all() throws -> [SuggestionEntity] {
        return []
    }

    func save(_ object: SuggestionEntity) throws {
        saveIsCalled = true
    }

    func deletePermanently(_ object: SuggestionEntity) throws {

    }
}

private class MainFlowControllerMock: MainFlowControllerType {
    var isShowCalled = false
    func getInitialController() -> UIViewController {
        return UIViewController()
    }

    func show(_ result: SearchResult, using keyword: String) {
        isShowCalled = true
    }

    var dependencies: MainFlowController.DependencyGroup {
        fatalError("Not needed")
    }
}
