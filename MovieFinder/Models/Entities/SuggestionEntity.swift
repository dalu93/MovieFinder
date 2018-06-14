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
final class SuggestionEntity: Object {
    @objc var keyword: String = ""

    override static func primaryKey() -> String {
        return "keyword"
    }
}

// MARK: - Entity
extension SuggestionEntity: Entity {}
