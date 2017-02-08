//
//  AppDelegate.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 04/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        coordinator = AppCoordinator(navigationController: navigationController)
        coordinator?.start()
        window?.makeKeyAndVisible()
    
        return true
    }
}
