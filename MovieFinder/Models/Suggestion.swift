//
//  Suggestion.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Suggestion declaration
struct Suggestion: Codable {
    let keyword: String
}

// MARK: - EntityRepresentable
extension Suggestion: EntityRepresentable {
    var entity: SuggestionEntity {
        return SuggestionEntity()
    }

    init(with entity: SuggestionEntity) {
        keyword = ""
    }
}
