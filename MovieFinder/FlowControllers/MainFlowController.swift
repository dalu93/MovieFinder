//
//  MainFlowController.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit

protocol MainFlowControllerType: FlowController where DependencyGroup == MainFlowController.DependencyGroup {
    func getInitialController() -> UIViewController
    func show(_ result: SearchResult, using keyword: String)
}

// MARK: - MainFlowController declaration
final class MainFlowController: MainFlowControllerType {
    struct DependencyGroup {
        let apiService: APIService
        let suggestionStore: SuggestionStore
    }

    let dependencies: DependencyGroup
    init(dependencies: DependencyGroup) {
        self.dependencies = dependencies
    }

    private weak var _navigationController: UINavigationController?

    func getInitialController() -> UIViewController {
        log.debug("Getting the initial ViewController")
        let viewModel = SearchViewModel<APIService, SuggestionStore, MainFlowController>(
            service: dependencies.apiService,
            flowController: self,
            suggestionStore: dependencies.suggestionStore
        )
        _navigationController = UINavigationController(
            rootViewController: SearchViewController(viewModel)
        )

        return _navigationController!
    }

    func show(_ result: SearchResult, using keyword: String) {
        log.debug("Getting the ListViewController for keyword: \(keyword)")
        let listViewModel = ListViewModel<APIService>(
            service: dependencies.apiService,
            keyword: keyword,
            searchResult: result
        )

        let listViewController = ListViewController(listViewModel)
        _navigationController?.pushViewController(listViewController, animated: true)
    }
}
