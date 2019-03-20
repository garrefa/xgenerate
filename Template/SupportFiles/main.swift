//
//  main.swift
//  Template
//
//  Created by AUTHOR on DATE.
//  Copyright © 2018 ORGNAME. All rights reserved.
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil

let appDelegateClass = isRunningTests ? TestAppDelegate.self : AppDelegate.self

_ = UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(appDelegateClass))
