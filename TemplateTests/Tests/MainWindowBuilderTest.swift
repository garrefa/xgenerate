//
//  WindowBuilderTest.swift
//  AXTemplateTests
//
//  Created by Alex Garrefa on 15/12/2018.
//  Copyright © 2018 Garrefa. All rights reserved.
//

import XCTest
@testable import Template

class MainWindowBuilderTest: XCTestCase {
    var sut: MainWindowBuilder!

    override func setUp() {
        sut = MainWindowBuilder()
    }

    override func tearDown() {
        sut = nil
    }

    func testCreateAppWindow() {
        _ = sut.createAppWindow()
        XCTAssertNotNil(sut.window)
    }

    func testSetAppRootViewController() {
        _ = sut
            .createAppWindow()
            .setAppRootViewController()

        AssertType(
            of: sut.window?.rootViewController,
            is: UINavigationController.self)

        let navController = sut.window?.rootViewController as? UINavigationController

        AssertSequence(
            navController?.viewControllers,
            numberOfElements: 1)

        AssertType(
            of: navController?.viewControllers.first,
            is: ViewController.self)
    }

    func testMakeKeyAndVisible() {
        _ = sut
            .createAppWindow()
            .setAppRootViewController()
            .makeKeyAndVisible()

        XCTAssertTrue(sut.window?.isKeyWindow ?? false)
    }
}
