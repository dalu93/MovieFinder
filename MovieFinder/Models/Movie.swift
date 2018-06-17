//
//  Movie.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Movie declaration
/// Describes a movie in the application
struct Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case name = "title"
        case release = "release_date"
        case overview
    }

    let posterPath: String?
    let name: String
    let release: String
    let overview: String
}

// MARK: - JSONRepresentable
extension Movie: JSONRepresentable {

    init(with jsonData: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Movie.self, from: jsonData)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

// MARK: - <#ListItemConvertible#>
extension Movie: ListItemConvertible {
    var listItem: ListItem {
        return ListItem(
            title: name,
            thubmnailUrl: nil,
            description: overview,
            subtitle: release
        )
    }
}

// MARK: - <#Equatable#>
extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.posterPath == rhs.posterPath &&
            lhs.name == rhs.name &&
            lhs.release == rhs.release &&
            lhs.overview == rhs.overview
    }
}
