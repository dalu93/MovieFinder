//
//  Realm+Store.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// MARK: - Realm Object extension for Storeable
extension RealmSwift.Object: Storeable {
    func save(using store: Realm) throws {
        try store.save(self)
    }

    func delete(using store: Realm) throws {
        try store.deletePermanently(self)
    }
}

// MARK: - Realm extension for Store
extension Realm: Store {
    func save(_ object: RealmSwift.Object) throws {
        try self.write {
            self.add(object)
        }
    }

    func deletePermanently(_ object: RealmSwift.Object) throws {
        self.delete(object)
    }
}
