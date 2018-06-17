//
//  ImageUrlProvider.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

/// Describes an object that provides a `URL` for an image path.
protocol ImageUrlProviderType {
    func imageUrlUsing(_ path: String) -> URL?
}
