//
//  CompletionSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MovieFinder

final class CompletionSpecs: QuickSpec {
    override func spec() {
        describe("[UT] When the result is success") {
            it("isSuccess should return true and value should be valid") {
                // GIVEN
                let completion = Completion<Int>.success(2)

                // THEN
                expect(completion.isSuccess).to(beTrue())
                expect(completion.isFailed).to(beFalse())
                expect(completion.value).to(equal(2))
                expect(completion.error).to(beNil())
            }
        }

        describe("[UT] When the result is failure") {
            it("isFailed should return true and error should be valid") {
                // GIVEN
                let error = NSError(
                    domain: "CompletionSpecs",
                    code: -1,
                    userInfo: nil
                )

                let completion = Completion<Int>.failed(error)

                // THEN
                expect(completion.isSuccess).to(beFalse())
                expect(completion.isFailed).to(beTrue())
                expect(completion.value).to(beNil())
                expect(completion.error as NSError?).to(equal(error))
            }
        }
    }
}
