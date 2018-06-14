//
//  ConnectionStatus.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - ConnectionStatus declaration
enum ConnectionStatus<Request, Value> {
    case notStarted
    case inProgress(Request)
    case completed(Completion<Value>)
}
