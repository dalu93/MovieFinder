//
//  DictionaryConvertible.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

protocol DictionaryConvertible {
    associatedtype ValueType
    var dictionary: [String: ValueType]? { get }
}

// MARK: - NSData
extension Data: DictionaryConvertible {
    var dictionary: [String: AnyObject]? {
        let serialized = try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return serialized as? [String: AnyObject]
    }
}
