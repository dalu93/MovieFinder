//
//  SuggestionSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/17/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import MovieFinder

final class SuggestionSpecs: QuickSpec {
    override func spec() {
        describe("Converting Suggestion to SuggestionEntity") {
            it("should keep all the correct values") {
                // GIVEN
                let suggestion = Suggestion(
                    keyword: "keyword",
                    createdAt: Date()
                )

                // WHEN
                let entity = suggestion.entity

                // THEN
                expect(entity.keyword).to(equal(suggestion.keyword))
                expect(entity.createdAt).to(equal(suggestion.createdAt))
            }
        }

        describe("Converting SuggestionEntity to Suggestion") {
            it("should keep all the correct values") {
                // GIVEN
                let suggestion = Suggestion(
                    keyword: "keyword",
                    createdAt: Date()
                )

                let entity = suggestion.entity

                // WHEN
                let finalSuggestion = Suggestion(with: entity)

                // THEN
                expect(finalSuggestion.keyword).to(equal(suggestion.keyword))
                expect(finalSuggestion.createdAt).to(equal(suggestion.createdAt))
            }
        }
    }
}
