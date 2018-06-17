//
//  SuggestionStoreSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/17/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RealmSwift
@testable import MovieFinder

final class SuggestionStoreSpecs: QuickSpec {
    override func spec() {
        let realmConfig = Realm.Configuration(inMemoryIdentifier: "in-memory-realm")
        let realm = try! Realm(configuration: realmConfig)
        let store = SuggestionStore(realm: realm)

        beforeEach {
            try! realm.write {
                realm.deleteAll()
            }
        }

        describe("[UT] When adding a Suggestion") {
            it("should store it correctly if there isn't an identical one already") {
                // GIVEN
                let suggestion = Suggestion(
                    keyword: "a",
                    createdAt: Date()
                )

                let entity = suggestion.entity
                var error: Error?
                var found: Bool = false

                // WHEN
                do {
                    try store.save(entity)
                    found = try store
                        .all()
                        .filter {
                            $0.keyword == suggestion.keyword && $0.createdAt == suggestion.createdAt
                        }.count == 1
                } catch let err {
                    error = err
                }

                // THEN
                expect(error).to(beNil())
                expect(found).to(beTrue())
            }

            it("should return an error if there is an identical one already") {
                // GIVEN
                let suggestion = Suggestion(
                    keyword: "a",
                    createdAt: Date()
                )

                let entity = suggestion.entity
                try! store.save(entity)

                var error: Error?

                // WHEN
                do {
                    try store.save(entity)
                } catch let err {
                    error = err
                }

                // THEN
                expect(error as? AppError.Store).to(equal(.alreadyExists))
            }
        }
    }
}
