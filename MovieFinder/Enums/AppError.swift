//
//  AppError.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - AppError declaration
enum AppError: Error {
    case invalidJson
    case noInternetConnection
}
