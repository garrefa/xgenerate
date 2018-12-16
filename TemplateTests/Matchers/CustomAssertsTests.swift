//
//  CustomAssertsTests.swift
//  AXTemplateTests
//
//  Created by Alex Garrefa on 15/12/2018.
//  Copyright © 2018 Garrefa. All rights reserved.
//

import XCTest

class CustomAssertsTests: ExpectedToFailTestCase {

    func testAssertSequenceShouldPass() {
        AssertSequence([], numberOfElements: 0)
        AssertSequence(0...9, numberOfElements: 10)
        AssertSequence(0...999_999, numberOfElements: 1_000_000)
    }

    func testAssertSequenceShouldFail() {
        let nilSeq: [Int]? = nil

        // The next 4 assertions are expected to fail
        // test suit should succeed if they fail
        // test suit should fail if they succeed
        setExpectAssertionsToFail(atLines: Set(#line+1...#line+4))
        AssertSequence(nilSeq, numberOfElements: 0)
        AssertSequence([], numberOfElements: 1)
        AssertSequence(0...9, numberOfElements: 11)
        AssertSequence(0...999_999, numberOfElements: 1_000_001)
    }

    func testAssertTypeShouldPass() {
        AssertType(of: UIViewController(), is: UIViewController.self)
        AssertType(of: UITableViewController(), is: UIViewController.self)
    }

    func testAssertTypeShouldFail() {
        // The next 3 assertions are expected to fail
        // test suit should succeed if they fail
        // test suit should fail if they succeed
        setExpectAssertionsToFail(atLines: Set(#line+1...#line+3))
        AssertType(of: nil, is: UIButton.self)
        AssertType(of: UIView(), is: UIButton.self)
        AssertType(of: UIViewController(), is: UITableViewController.self)
    }
}

class ExpectedToFailTestCase : XCTestCase {
    private var linesExpectedToFail: Set<Int> = []
    private var failedLines: Set<Int> = []
    private var fileName: StaticString!

    func setExpectAssertionsToFail(
        atLines: Set<Int>,
        file: StaticString = #file) {

        linesExpectedToFail = atLines
        fileName = file
    }

    override func setUp() {
        // Make sure to always call super.setUp() when subclassing
        linesExpectedToFail = []
        failedLines = []
    }

    override func tearDown() {
        let linesExpectedToFailCopy = linesExpectedToFail
        linesExpectedToFail = []
        linesExpectedToFailCopy
            .subtracting(failedLines)
            .forEach { line in
                XCTFail(
                    "Assertion was expected to fail but succeed",
                    file: fileName,
                    line: UInt(line))
        }
        fileName = nil
    }

    override func recordFailure(
        withDescription description: String,
        inFile filePath: String,
        atLine lineNumber: Int,
        expected: Bool) {

        guard expected, linesExpectedToFail.contains(lineNumber) else {
            // Normal failure behaviour for non expected failures
            super.recordFailure(
                withDescription: description,
                inFile: filePath,
                atLine: lineNumber,
                expected: expected)
            return
        }

        // Ignore expected failures but store failed line
        failedLines.insert(lineNumber)
    }
}
