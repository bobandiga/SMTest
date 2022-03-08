//
//  AppDelegate.swift
//  SHMXTest
//
//  Created by bobandiga on 12/27/2021.
//  Copyright (c) 2021 bobandiga. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(#function)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
    }
}
