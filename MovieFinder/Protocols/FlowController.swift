//
//  FlowController.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

protocol FlowController {
    associatedtype DependencyGroup
    var dependencies: DependencyGroup { get }
}
