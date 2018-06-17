//
//  TMDBImageUrlProvider.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - TMDBImageUrlProvider declaration
/// Provides the full URL for the posters.
struct TMDBImageUrlProvider: ImageUrlProviderType {

    /// Provides the full URL for the posters.
    ///
    /// - Parameter path: The path returned by the API.
    /// - Returns: The complete URL.
    func imageUrlUsing(_ path: String) -> URL? {
        return URL(string: "http://image.tmdb.org/t/p/w92" + path)
    }
}
