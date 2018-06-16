//
//  Log.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

func setupLogger() {
    log.addDestination(ConsoleDestination())
}
