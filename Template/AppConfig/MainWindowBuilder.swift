//
//  MainWindowBuilder.swift
//  AXTemplate
//
//  Created by Alex Garrefa on 15/12/2018.
//  Copyright © 2018 Garrefa. All rights reserved.
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
