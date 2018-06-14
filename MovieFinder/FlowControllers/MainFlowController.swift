//
//  MainFlowController.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MainFlowController declaration
struct MainFlowController: FlowController {
    struct DependencyGroup {
        let apiService: APIService
    }

    let dependencies: DependencyGroup

    var startController: UIViewController {
        let viewModel = SearchViewModel<APIService>(dependencies.apiService, flowController: self)
        return UINavigationController(
            rootViewController: SearchViewController(viewModel)
        )
    }

    func show(_ result: SearchResult) {
        dump(result)
    }
}
