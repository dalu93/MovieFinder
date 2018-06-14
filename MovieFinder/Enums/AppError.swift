//
//  AppError.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

protocol AppErrorType: Error, CustomStringConvertible {}

// MARK: - AppError declaration
enum AppError {

    // MARK: - Request declaration
    enum Request: AppErrorType {
        case invalidResponseData
        case invalidStatusCode(Int)
        case invalidConnection

        var description: String {
            switch self {
            case .invalidResponseData, .invalidStatusCode:
                return "A server error occurred. Please, try again."

            case .invalidConnection:
                return "Please, check your internet connection and try again."
            }
        }
    }

    enum Search: AppErrorType {
        case invalidKeyword
        case noResults

        var description: String {
            switch self {
            case .invalidKeyword:
                return "The keyword must not be empty"

            case .noResults:
                return "No results were found for the specified keyword"
            }
        }
    }
}
