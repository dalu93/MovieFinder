//
//  ListCellDisplayable.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - ListCellDisplayable declaration
protocol ListCellDisplayable {
    var title: String { get }
    var thubmnailUrl: URL? { get }
    var description: String { get }
    var subtitle: String { get }
}

// MARK: - ListItem declaration
struct ListItem: ListCellDisplayable {
    let title: String
    let thubmnailUrl: URL?
    let description: String
    let subtitle: String
}

// MARK: - ListItemConvertible
protocol ListItemConvertible {
    var listItem: ListItem { get }
}
