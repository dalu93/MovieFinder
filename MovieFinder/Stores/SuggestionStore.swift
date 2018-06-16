//
//  SuggestionStore.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - SuggestionStore declaration
struct SuggestionStore: Store {
    // MARK: - Properties
    // MARK: Public properties
    let realm: Realm

    // MARK: - Methods
    // MARK: Public methods
    func save(_ object: SuggestionEntity) throws {
        try realm.save(object)
    }

    func deletePermanently(_ object: SuggestionEntity) throws {
        realm.delete(object)
    }
}
