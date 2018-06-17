//
//  AppDelegate.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var _apiService: APIService = {
        return APIService(
            baseAPIURL: "http://api.themoviedb.org/3",
            imageUrlProvider: TMDBImageUrlProvider(),
            sessionConfiguration: .default
        )
    }()

    private lazy var _realm: Realm = {
        do {
            let realm = try Realm()
            log.info("Realm created. File can be found at \(realm.configuration.fileURL!)")
            return realm
        } catch {
            log.error("Couldn't create application realm")
            fatalError("[DEV ERROR] Failed to create application realm")
        }
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        // Setup the logger
        setupLogger()

        // Initialize the application
        let suggestionStore = SuggestionStore(realm: _realm)
        let flowController = MainFlowController(
            dependencies: MainFlowController.DependencyGroup(
                apiService: _apiService,
                suggestionStore: suggestionStore
            )
        )

        let startController = flowController.getInitialController()
        window!.rootViewController = startController
        window!.makeKeyAndVisible()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
