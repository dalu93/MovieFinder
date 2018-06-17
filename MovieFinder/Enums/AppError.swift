//
//  AppError.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

/// Describes the generic application error that can be handled.
protocol AppErrorType: Error, CustomStringConvertible {}

// MARK: - AppError declaration
enum AppError {

    // MARK: - Request declaration
    /// The `Request` error enum represents all the possible errors that can
    /// happen when requesting anything to a web service.
    ///
    /// - invalidResponseData: The response data is invalid (count = 0) or is `nil`.
    /// - invalidStatusCode: The status code is not in the 200..<300 range.
    /// - invalidConnection: The connection is invalid (timeout/no internet connection).
    enum Request: AppErrorType, Equatable {
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

        static func == (lhs: Request, rhs: Request) -> Bool {
            switch (lhs, rhs) {
            case (.invalidResponseData, .invalidResponseData):
                return true

            case (.invalidConnection, .invalidConnection):
                return true

            case (.invalidStatusCode(let statusCodeL), .invalidStatusCode(let statusCodeR)):
                return statusCodeL == statusCodeR

            default:
                return false
            }
        }
    }

    // MARK: - Search declaration
    /// The `Search` error enum represents all kind of errors that can happen
    /// when searching for a movie
    ///
    /// - invalidKeyword: The provided keyword is invalid.
    /// - noResults: The keyword didn't produce any valid result.
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

    // MARK: - List declaration
    /// The `List` error enum represents all kind of errors that can happen
    /// when viewing the list page.
    ///
    /// - loadingNextPageFailed: The app failed to download the next page of results.
    enum List: AppErrorType {
        case loadingNextPageFailed

        var description: String {
            switch self {
            case .loadingNextPageFailed:
                return "An error occurred. Tap to retry"
            }
        }
    }

    // MARK: - Store declaration
    /// The `Store` error enum represents all kind of errors that can happen
    /// when storing a value.
    ///
    /// - alreadyExists: The value you're trying to store already exists in the database.
    enum Store: AppErrorType {
        case alreadyExists

        var description: String {
            switch self {
            case .alreadyExists:
                return "The item already exists in database"
            }
        }
    }
}
