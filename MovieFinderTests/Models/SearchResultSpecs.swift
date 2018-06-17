//
//  SearchResultSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MovieFinder

final class SearchResultSpecs: QuickSpec {
    override func spec() {
        describe("[UT] Loading search result from a valid JSON") {
            it("should return a valid SearchResult") {
                // GIVEN
                let bundle = Bundle(for: type(of: self))
                let url = bundle.url(
                    forResource: "search_result",
                    withExtension: "json"
                )!

                let searchResultData = try! Data(contentsOf: url)
                let expectedSearchResult = SearchResult(
                    page: 1,
                    totalResults: 0,
                    totalPages: 1,
                    results: []
                )

                // WHEN
                let searchResult = try! JSONDecoder()
                    .decode(SearchResult.self, from: searchResultData)

                // THEN
                expect(searchResult).to(equal(expectedSearchResult))
            }
        }
    }
}
