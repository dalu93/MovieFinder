//
//  ReusableView.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Protocols definition
/**
 *  Describes an initializable class from UINib
 */
protocol NibConvertible {
    static var nibName: String { get }
}

/**
 *  Identifier for class
 */
protocol IdentifierConvertible {
    static var identifier: String { get }
}

/**
 *  A reusable view
 */
protocol ReusableView: NibConvertible, IdentifierConvertible {}

 extension NibConvertible {
    /// The nib name. It is the self class name stringified
    static var nibName: String { return String(describing: Self.self) }
}

 extension IdentifierConvertible {
    /// The identifier. It is the self class name stringified
    static var identifier: String { return String(describing: Self.self) }
}

// MARK: - Nib instantiation
 extension NibConvertible {

    /// The `UINib` instance initialized by using the property `nibName`
    static var nib: UINib { return UINib.nibFrom(string: Self.nibName) }
}

// MARK: - UINib extension
import UIKit
extension UINib {

    static func nibFrom(string: String, bundle: Bundle? = nil) -> UINib {
        return UINib(
            nibName: string,
            bundle: bundle
        )
    }
}

extension UIView {
    class func fromNib<T>() -> T where T: UIView, T: NibConvertible {
        guard let view = Bundle.main.loadNibNamed(T.nibName, owner: self, options: nil)?.first as? T else { fatalError("No \(T.nibName) available") }
        return view
    }
}
