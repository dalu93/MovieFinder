//
//  Suggestion.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Suggestion declaration
/// Describes a suggestion to be shown to the user when searching for a movie.
struct Suggestion {
    let keyword: String
    let createdAt: Date
}

// MARK: - EntityRepresentable
extension Suggestion: EntityRepresentable {
    var entity: SuggestionEntity {
        let entity = SuggestionEntity()
        entity.keyword = keyword
        entity.createdAt = createdAt
        return entity
    }

    init(with entity: SuggestionEntity) {
        self.keyword = entity.keyword
        self.createdAt = entity.createdAt
    }
}
