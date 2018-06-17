//
//  ListCellDisplayable.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - ListCellDisplayable declaration
/// Describes an item displayable in the `ListTableViewCell`.
protocol ListCellDisplayable {
    var title: String { get }
    var thubmnailUrl: URL? { get }
    var description: String { get }
    var subtitle: String { get }
}

// MARK: - ListItem declaration
/// An item that can be displayed in the `ListTableViewCell`.
struct ListItem: ListCellDisplayable {
    let title: String
    let thubmnailUrl: URL?
    let description: String
    let subtitle: String
}

// MARK: - ListItemConvertible
/// Describes an object that can be coverted to `ListItem`.
protocol ListItemConvertible {
    var listItem: ListItem { get }
}
