//
//  ArrayExtensions.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

extension Array {
    func get(at index: Int) -> Element? {
        guard count > index else { return nil }
        return self[index]
    }
}
