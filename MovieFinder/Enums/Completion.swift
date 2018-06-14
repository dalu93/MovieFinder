//
//  Completion.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Completion declaration
/**
 The enum describes a completion status.

 - success: The operation was completed with success
 - failed:  The operation was completed with error
 */
enum Completion<Value> {
    case success(Value)
    case failed(NSError)

    /// Succeeded or not
    var isSuccess: Bool {
        if case .success(_) = self { return true } else { return false }
    }

    /// Failed or not
    var isFailed: Bool { return !isSuccess }

    /// The associated value if the operation was completed with success
    var value: Value? {
        switch self {
        case .success(let value):       return value
        case .failed:                   return nil
        }
    }

    /// The associated error if the operation was completed with error
    var error: NSError? {
        switch self {
        case .success:              return nil
        case .failed(let error):    return error
        }
    }
}
