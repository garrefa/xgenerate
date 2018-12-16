//
//  main.swift
//  AXTemplate
//
//  Created by Alex Garrefa on 15/12/2018.
//  Copyright © 2018 Garrefa. All rights reserved.
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil

let appDelegateClass = isRunningTests ? TestAppDelegate.self : AppDelegate.self

_ = UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(appDelegateClass))
