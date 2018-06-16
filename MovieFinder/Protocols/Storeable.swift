//
//  Storeable.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Store declaration
/// The `Store` is a structure which is able to store a `Storeable` object.
/// The basic actions are `save()` and `deletePermanently()`.
protocol Store {
    associatedtype Object: Storeable
    func all() throws -> [Object]
    func save(_ object: Object) throws
    func deletePermanently(_ object: Object) throws
}

// MARK: - Storeable
/// Use a `Store` to save in a specific storage a `Storeable` structure.
protocol Storeable {
    associatedtype AssociatedStore: Store
    func save(using store: AssociatedStore) throws
    func delete(using store: AssociatedStore) throws
}
