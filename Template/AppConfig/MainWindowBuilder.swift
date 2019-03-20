//
//  MainWindowBuilder.swift
//  Template
//
//  Created by AUTHOR on DATE.
//  Copyright © 2018 ORGNAME. All rights reserved.
//

import UIKit.UIWindow

class MainWindowBuilder: NSObject {

    var window: UIWindow?

    func createAppWindow() -> MainWindowBuilder {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        return self
    }

    func setAppRootViewController() -> MainWindowBuilder {
        window?.rootViewController =
            UINavigationController(rootViewController: ViewController())
        return self
    }

    func makeKeyAndVisible() -> UIWindow? {
        window?.makeKeyAndVisible()
        return window
    }
}
