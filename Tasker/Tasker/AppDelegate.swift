//
//  AppDelegate.swift
//  Tasker
//
//  Created by kevin flores on 10/21/19.
//  Copyright © 2019 kevin flores. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationViewController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        
        return true
    }
}

