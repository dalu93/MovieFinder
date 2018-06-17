//
//  DictionaryConvertible.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - DictionaryConvertible declaration
/// Describes an object that can be converted to `Dictionary`.
protocol DictionaryConvertible {
    associatedtype ValueType
    var dictionary: [String: ValueType]? { get }
}
