//
//  SuggestionStore.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import RealmSwift

protocol SuggestionStoreType: Store where Object == SuggestionEntity {}

// MARK: - SuggestionStore declaration
struct SuggestionStore: SuggestionStoreType {
    // MARK: - Properties
    // MARK: Public properties
    let realm: Realm

    // MARK: - Methods
    // MARK: Public methods
    func all() throws -> [SuggestionEntity] {
        log.debug("Retrieving all SuggestionEntity")
        return Array(realm.objects(SuggestionEntity.self))
    }
    func save(_ object: SuggestionEntity) throws {
        log.debug("Saving a new SuggestionEntity with keyword: \(object.keyword)")
        guard realm.object(ofType: SuggestionEntity.self, forPrimaryKey: object.keyword) == nil else {
            log.error("Not saving the Suggestion with keyword: \(object.keyword). It already exists in Realm")
            throw AppError.Store.alreadyExists
        }

        try realm.save(object)
    }

    func deletePermanently(_ object: SuggestionEntity) throws {
        log.debug("Deleting SuggestionEntity with keyword: \(object.keyword)")
        realm.delete(object)
    }
}
