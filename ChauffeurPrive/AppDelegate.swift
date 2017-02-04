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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            window.rootViewController = MapViewController()
            window.makeKeyAndVisible()
        }
        return true
    }
}
