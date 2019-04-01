//
//  AppDelegate.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let services = Services()

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MoviesViewController(viewModel: MoviesViewModel(services: services)))
    }
}
