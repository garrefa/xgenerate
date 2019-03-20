//
//  CustomAsserts.swift
//  TemplateTests
//
//  Created by AUTHOR on DATE.
//  Copyright © 2018 ORGNAME. All rights reserved.
//

import XCTest

/// Asserts that a sequence has the expected number of elements
///
/// - Parameters:
///   - seq: the sequence to assert number of elements
///   - numberOfElements: expected number of elements in the sequence
///   - message: optional failure message
///   - file: file name to point at on assertion failure
///   - line: line number in file name to point at on assertion failure

// swiftlint:disable:next identifier_name
func AssertSequence<Seq: Sequence>(
    _ seq: Seq?,
    numberOfElements: Int,
    message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line) {

    guard let seq = seq else {
        XCTFail("Sequence is nil", file: file, line: line)
        return
    }
    let count: Int = seq.reduce(0) { (acc, _) -> Int in acc + 1 }
    guard let message = message else {
        XCTAssertEqual(count, numberOfElements, file: file, line: line)
        return
    }
    XCTAssertEqual(count, numberOfElements, message, file: file, line: line)
}

/// Assert that a object has the expected type
///
/// - Parameters:
///   - obj: object to assert type
///   - expectedType: expected type of object
///   - message: optional failure message
///   - file: file name to point at on assertion failure
///   - line: line number in file name to point at on assertion failure

// swiftlint:disable:next identifier_name
func AssertType(
    of obj: AnyObject?,
    is expectedType: AnyClass,
    message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line) {

    guard let obj = obj else {
        XCTFail("Object is nil", file: file, line: line)
        return
    }
    guard let message = message else {
        XCTAssertTrue(obj.isKind(of: expectedType), file: file, line: line)
        return
    }
    XCTAssertTrue(obj.isKind(of: expectedType), message, file: file, line: line)
}
