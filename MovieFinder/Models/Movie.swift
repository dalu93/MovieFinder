//
//  Movie.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Movie declaration
struct Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case posterUrl = "poster_path"
        case name = "title"
        case release = "release_date"
        case overview
    }

    let posterUrl: URL?
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
