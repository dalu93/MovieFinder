//
//  HTTPHeaderSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MovieFinder

final class HTTPHeaderSpecs: QuickSpec {

    override func spec() {
        describe("Converting the struct in a dictionary") {
            it("the dictionary should contain the correct key and value") {
                // GIVEN
                let header = HTTPHeader(
                    name: "Authentication",
                    value: "Bearer yteidj6"
                )

                // WHEN
                let dictionary = header.dictionary!

                // THEN
                expect(dictionary.keys.count).to(equal(1))
                expect(dictionary["Authentication"]).to(equal("Bearer yteidj6"))
            }
        }
    }
}
