//
//  AppDelegate.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import GoogleMaps
import GoogleNavigation
import Logging
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configMap()
        configRootController()
        return true
    }

    func configMap() {
        GMSServices.provideAPIKey(CTGoogleMapsKey)
    }

    func configRootController() {
        window?.rootViewController = UINavigationController(rootViewController: CTHomeViewController())
        window?.makeKeyAndVisible()
    }
}
