//
//  UITableViewExtensions.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    /**
     Asks a `ReusableView` instance dequeued from the `UITableView`.

     Example: \
     \
     `let cell: YourCellClass = tableView.dequeueReusableCell()` \
     where `YourCellClass` is a `UITableViewCell` conforming to `ReusableView` protocol

     - Note:    It raises an exception when a `UITableViewCell` instance cannot be
     dequeued.

     - SeeAlso: `ReusableView`

     - returns: Dequeue `UITableViewCell` instance
     */
    func dequeueReusableCell<T>() -> T where T: UITableViewCell, T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier) as? T else {
            fatalError("A cell with \(T.identifier) identifier cannot be dequeued")
        }

        return cell
    }

    /**
     Asks a `UITableViewCell` instance dequeued from the `UITableView`.

     Example: \
     \
     `let cell: YourCellClass = tableView.dequeueReusableCell()` \
     where `YourCellClass` is a `UITableViewCell`

     - Note:    It raises an exception when a `UITableViewCell` instance cannot be
     dequeued.

     - Note:    The cell identifier **must** be equal to the class name

     - returns: Dequeue `UITableViewCell` instance
     */
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("A cell with \(identifier) identifier cannot be dequeued")
        }

        return cell
    }

    /**
     Registers the cell for the `UITableView` instance.

     The cell has to conform to `ReusableView` protocol.

     - SeeAlso: `ReusableView`

     - parameter type: The cell type
     */
    func registerCell<T>(_ type: T.Type) where T: UITableViewCell, T: ReusableView {
        register(
            T.nib,
            forCellReuseIdentifier: T.identifier
        )
    }

    /**
     Registers the cell for the `UITableView` instance.

     - parameter type: The cell type
     */
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    /**
     Tells the `UITableView` instance to set the row dimension as automatic

     - parameter estimatedRowHeight: The estimated row height. Default is `100`
     */
    func setupAutomaticDimension(to estimatedRowHeight: CGFloat = 100) {
        self.estimatedRowHeight = estimatedRowHeight
        self.rowHeight = UITableViewAutomaticDimension
    }
}
