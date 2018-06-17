//
//  ConnectionStatus.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - ConnectionStatus declaration
/// Describes all the phases of a remote connection.
///
/// - notStarted: The request didn't start yet.
/// - inProgress: The request is in progress.
/// - completed: The request is completed (either failure or success)
enum ConnectionStatus<Request, Value> {
    case notStarted
    case inProgress(Request)
    case completed(Completion<Value>)

    var isInProgress: Bool {
        switch self {
        case .inProgress:               return true
        case .notStarted, .completed:   return false
        }
    }
}
