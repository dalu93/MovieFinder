//
//  SuggestionEntity.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

// MARK: - SuggestionEntity declaration
/// The entity of `Suggestion`.
///
/// The different instance helps and prevents any thread issues and improves
/// security on what is stored in database.
final class SuggestionEntity: Object {
    @objc dynamic var keyword: String = ""
    @objc dynamic var createdAt: Date = Date()

    override static func primaryKey() -> String {
        return "keyword"
    }
}

// MARK: - Entity
extension SuggestionEntity: Entity {}
