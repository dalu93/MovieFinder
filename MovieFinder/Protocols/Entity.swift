//
//  Entity.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Entity declaration
/// An `Entity` is a `Storeable` representation of an application model.
protocol Entity: Storeable {}

// MARK: - EntityRepresentable
/// By conforming to this protocol, the structure can be converted to and
/// initied from a specific `Entity`.
protocol EntityRepresentable {
    associatedtype Entity

    var entity: Entity { get }
    init(with entity: Entity)
}
