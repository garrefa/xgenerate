//
//  AppDelegate.swift
//  Template
//
//  Created by AUTHOR on DATE.
//  Copyright © 2018 ORGNAME. All rights reserved.
//

import UIKit

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {

        window = MainWindowBuilder()
            .createAppWindow()
            .setAppRootViewController()
            .makeKeyAndVisible()

        return true
    }

}
