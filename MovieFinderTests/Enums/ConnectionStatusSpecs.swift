//
//  ConnectionStatusSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MovieFinder

final class ConnectionStatusSpecs: QuickSpec {
    override func spec() {
        describe("When the connection status is in progress") {
            it("should return true when calling isInProgress") {
                // GIVEN
                let status = ConnectionStatus<Any, Any>.inProgress("")

                // THEN
                expect(status.isInProgress).to(beTrue())
            }
        }

        describe("When the connection status is not in progress") {
            it("should return false when calling isInProgress") {
                // GIVEN
                let status = ConnectionStatus<Any, Any>.notStarted

                // THEN
                expect(status.isInProgress).to(beFalse())
            }
        }
    }
}
