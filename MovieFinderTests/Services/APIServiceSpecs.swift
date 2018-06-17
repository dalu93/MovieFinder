//
//  APIServiceSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/17/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import MovieFinder

final class APIServiceSpecs: QuickSpec {
    override func spec() {
        let stub = APIServiceStub()
        let apiService = APIService(
            baseAPIURL: "http://a-test.com",
            imageUrlProvider: TMDBImageUrlProvider(),
            sessionConfiguration: .default
        )

        beforeEach {
            stub.reset()
        }

        context("[UT] When connecting to the API results in an error") {
            describe("if the error is due to internet connection") {
                it("should explain correctly the reason of the failure") {
                    // GIVEN
                    var actualResult: Completion<SearchResult>!

                    // WHEN
                    stub.simulateConnectionError()
                    _ = SearchResult.get(
                        with: "keyword",
                        at: 1,
                        using: apiService,
                        completion: { result in
                            actualResult = result
                        }
                    )

                    // THEN
                    expect(actualResult).toEventuallyNot(beNil())
                    expect(actualResult.isFailed)
                        .toEventually(beTrue())
                    expect(actualResult.error as? AppError.Request)
                        .toEventually(equal(.invalidConnection))
                }
            }

            describe("if the error is due to server error") {
                it("should explain correctly the reason of the failure") {
                    // GIVEN
                    var actualResult: Completion<SearchResult>!

                    // WHEN
                    stub.simulateWrongStatusCode()
                    _ = SearchResult.get(
                        with: "keyword",
                        at: 1,
                        using: apiService,
                        completion: { result in
                            actualResult = result
                        }
                    )

                    // THEN
                    expect(actualResult).toEventuallyNot(beNil())
                    expect(actualResult.isFailed)
                        .toEventually(beTrue())
                    expect(actualResult.error as? AppError.Request)
                        .toEventually(equal(.invalidStatusCode(500)))
                }
            }

            describe("if the error is due to missing data in the response") {
                it("should explain correctly the reason of the failure") {
                    // GIVEN
                    var actualResult: Completion<SearchResult>!

                    // WHEN
                    stub.simulateCorruptedData()
                    _ = SearchResult.get(
                        with: "keyword",
                        at: 1,
                        using: apiService,
                        completion: { result in
                            actualResult = result
                    }
                    )

                    // THEN
                    expect(actualResult).toEventuallyNot(beNil())
                    expect(actualResult.isFailed)
                        .toEventually(beTrue())
                    expect(actualResult.error as? AppError.Request)
                        .toEventually(equal(.invalidResponseData))
                }
            }

            describe("if the error is due to wrong json in the response") {
                it("should explain correctly the reason of the failure") {
                    // GIVEN
                    var actualResult: Completion<SearchResult>!

                    // WHEN
                    stub.simulateWrongJSON()
                    _ = SearchResult.get(
                        with: "keyword",
                        at: 1,
                        using: apiService,
                        completion: { result in
                            actualResult = result
                    }
                    )

                    // THEN
                    expect(actualResult).toEventuallyNot(beNil())
                    expect(actualResult.isFailed)
                        .toEventually(beTrue())
                    expect(actualResult.error as? AppError.Request)
                        .toEventually(equal(.invalidResponseData))
                }
            }
        }

        describe("[UT] When connecting to the API results in a success") {
            it("should convert the JSON to the particular object") {
                // GIVEN
                var actualResult: Completion<SearchResult>!
                let expectedSearchResult = SearchResult(
                    page: 1,
                    totalResults: 0,
                    totalPages: 1,
                    results: []
                )

                // WHEN
                stub.simulateCorrectJSON()
                _ = SearchResult.get(
                    with: "keyword",
                    at: 1,
                    using: apiService,
                    completion: { result in
                        actualResult = result
                }
                )

                // THEN
                expect(actualResult).toEventuallyNot(beNil())
                expect(actualResult.isSuccess)
                    .toEventually(beTrue())
                expect(actualResult.value)
                    .toEventually(equal(expectedSearchResult))
            }
        }
    }
}

private class APIServiceStub {
    func reset() {
        OHHTTPStubs.removeAllStubs()
    }

    func simulateConnectionError() {
        stub(
            condition: isHost("a-test.com")
        ) { _ in
            let notConnectedError = NSError(
                domain: NSURLErrorDomain,
                code: URLError.notConnectedToInternet.rawValue,
                userInfo: nil
            )

            return OHHTTPStubsResponse(error: notConnectedError)
        }
    }

    func simulateWrongStatusCode() {
        stub(
            condition: isHost("a-test.com")
        ) { _ in
            return OHHTTPStubsResponse(
                data: Data(),
                statusCode: 500,
                headers: nil
            )
        }
    }

    func simulateCorruptedData() {
        stub(
            condition: isHost("a-test.com")
        ) { _ in
            return OHHTTPStubsResponse(
                data: Data(),
                statusCode: 200,
                headers: nil
            )
        }
    }

    func simulateWrongJSON() {
        let json = ["something": "value"]
        let data = try! JSONEncoder().encode(json)

        stub(
            condition: isHost("a-test.com")
        ) { _ in
            return OHHTTPStubsResponse(
                data: data,
                statusCode: 200,
                headers: nil
            )
        }
    }

    func simulateCorrectJSON() {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "search_result", withExtension: "json")!
        stub(
            condition: isHost("a-test.com")
        ) { _ in
            return OHHTTPStubsResponse(
                fileURL: url,
                statusCode: 200,
                headers: nil
            )
        }
    }
}
