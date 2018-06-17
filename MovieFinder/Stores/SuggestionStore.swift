//
//  SuggestionStore.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import RealmSwift
// MARK: - SuggestionStoreType declaration
/// Description of a basic `SuggestionStore` capable of handling `SuggestionEntity`.
protocol SuggestionStoreType: Store where Object == SuggestionEntity {}

// MARK: - SuggestionStore declaration
/// Implementation of `SuggestionStoreType`.
///
/// Responsible for connection to database and handling of `SuggestionEntity` only.
struct SuggestionStore: SuggestionStoreType {
    // MARK: - Properties
    // MARK: Public properties
    /// The `Realm` instance being used.
    let realm: Realm

    // MARK: - Methods
    // MARK: Public methods
    /// Retrieves all the `SuggestionEntity` in the database.
    ///
    /// - Returns: All the `SuggestionEntity` in the database.
    /// - Throws: It doesn't throw. Just for protocol's conformance.
    func all() throws -> [SuggestionEntity] {
        log.debug("Retrieving all SuggestionEntity")
        return Array(realm.objects(SuggestionEntity.self))
    }

    /// Saves the `SuggestionEntity` in the database.
    ///
    /// - Parameter object: The `SuggestionEntity` to save.
    /// - Throws: Can throw `AppError.Store.alreadyExists` if the entity already exists
    /// in the database
    func save(_ object: SuggestionEntity) throws {
        log.debug("Saving a new SuggestionEntity with keyword: \(object.keyword)")
        guard realm.object(ofType: SuggestionEntity.self, forPrimaryKey: object.keyword) == nil else {
            log.error("Not saving the Suggestion with keyword: \(object.keyword). It already exists in Realm")
            throw AppError.Store.alreadyExists
        }

        try realm.save(object)
    }

    /// Deletes the `SuggestionEntity` from database
    ///
    /// - Parameter object: The `SuggestionEntity` to delete.
    /// - Throws: It doesn't throw. Just for protocol's conformance.
    func deletePermanently(_ object: SuggestionEntity) throws {
        log.debug("Deleting SuggestionEntity with keyword: \(object.keyword)")
        realm.delete(object)
    }
}
