//
//  APIConnectable.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - APIConnectable declaration
/// Describes a structure which is able to load resources.
protocol APIConnectable {
    associatedtype RequestType
    associatedtype ImageUrlProvider: ImageUrlProviderType

    var baseAPIURL: String { get }
    var imageUrlProvider: ImageUrlProvider { get }
    func load<Object>(resource: Resource<Object>, completion: @escaping (Completion<Object>) -> Void) -> RequestType
}
