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

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        setupLogger()
        let apiService = APIService(
            baseAPIURL: "http://api.themoviedb.org/3",
            sessionConfiguration: .default
        )

        var realm: Realm!
        do {
            realm = try Realm()
            log.info("Realm created. File can be found at \(realm.configuration.fileURL!)")
        } catch {
            log.error("Couldn't create application realm")
            fatalError("[DEV ERROR] Failed to create application realm")
        }

        let flowController = MainFlowController(
            dependencies: MainFlowController.DependencyGroup(
                apiService: apiService,
                suggestionStore: SuggestionStore(realm: realm)
            )
        )

        let startController = flowController.startController
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
