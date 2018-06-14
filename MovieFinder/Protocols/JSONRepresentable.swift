//
//  JSONRepresentable.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - JSONDecodable
/// `JSONDecodable` represents a structure that can be
/// initied using a JSON binary.
protocol JSONDecodable {
    init(with jsonData: Data) throws
}

// MARK: - JSONEncodable
/// `JSONEncodable` represents a structure that can be
/// coverted to a JSON binary.
protocol JSONEncodable {
    func jsonData() throws -> Data
}

// MARK: - JSONRepresentable
/// `JSONRepresentable` represents a structure that can be
/// initied from and coverted to a JSON binary.
protocol JSONRepresentable: JSONDecodable, JSONEncodable {}
