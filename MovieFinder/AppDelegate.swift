//
//  AppDelegate.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        let apiService = APIService(
            baseAPIURL: "http://api.themoviedb.org/3",
            sessionConfiguration: .default
        )

        let flowController = MainFlowController(
            dependencies: MainFlowController.DependencyGroup(
                apiService: apiService
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
