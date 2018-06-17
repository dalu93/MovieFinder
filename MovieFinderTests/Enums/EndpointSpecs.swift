//
//  EndpointSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MovieFinder

final class EndpointSpecs: QuickSpec {

    override func spec() {
        describe("[UT] Converting the parameters array in a dictionary") {
            it("the dictionary should contain the correct keys and values") {
                // GIVEN
                let params = [
                    Parameter(field: "field1", value: 1),
                    Parameter(field: "field2", value: "2")
                ]

                let endpoint = Endpoint(
                    path: "",
                    method: .get,
                    parameters: params,
                    headers: nil
                )

                // WHEN
                let paramsDictionary = endpoint.parameters

                // THEN
                expect(paramsDictionary).toNot(beNil())
                expect(paramsDictionary?.keys.count).to(equal(2))
                expect(paramsDictionary?["field1"] as? Int).to(equal(1))
                expect(paramsDictionary?["field2"] as? String).to(equal("2"))
            }

            it("should be nil if initialized with nil parameters") {
                // GIVEN
                let endpoint = Endpoint(
                    path: "",
                    method: .get,
                    parameters: nil,
                    headers: nil
                )

                // WHEN
                let paramsDictionary = endpoint.parameters

                // THEN
                expect(paramsDictionary).to(beNil())
            }

            it("should be empty if initialized with empty parameters") {
                // GIVEN
                let endpoint = Endpoint(
                    path: "",
                    method: .get,
                    parameters: [],
                    headers: nil
                )

                // WHEN
                let paramsDictionary = endpoint.parameters

                // THEN
                expect(paramsDictionary).toNot(beNil())
                expect(paramsDictionary?.keys.isEmpty).to(beTrue())
            }
        }

        describe("[UT] Converting the headers array in a dictionary") {
            it("the dictionary should contain the correct keys and values") {
                // GIVEN
                let headers = [
                    HTTPHeader(name: "field1", value: "1"),
                    HTTPHeader(name: "field2", value: "2")
                ]

                let endpoint = Endpoint(
                    path: "",
                    method: .get,
                    parameters: nil,
                    headers: headers
                )

                // WHEN
                let headersDictionary = endpoint.headers

                // THEN
                expect(headersDictionary).toNot(beNil())
                expect(headersDictionary?.keys.count).to(equal(2))
                expect(headersDictionary?["field1"]).to(equal("1"))
                expect(headersDictionary?["field2"]).to(equal("2"))
            }

            it("should be nil if initialized with nil parameters") {
                // GIVEN
                let endpoint = Endpoint(
                    path: "",
                    method: .get,
                    parameters: nil,
                    headers: nil
                )

                // WHEN
                let headersDictionary = endpoint.headers

                // THEN
                expect(headersDictionary).to(beNil())
            }

            it("should be empty if initialized with empty parameters") {
                // GIVEN
                let endpoint = Endpoint(
                    path: "",
                    method: .get,
                    parameters: nil,
                    headers: []
                )

                // WHEN
                let headersDictionary = endpoint.headers

                // THEN
                expect(headersDictionary).toNot(beNil())
                expect(headersDictionary?.keys.isEmpty).to(beTrue())
            }
        }
    }
}

