//  Project name: FwiCore
//  File name   : FwiDecodeOperatorTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/1/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import XCTest
@testable import FwiCore


class FwiDecodeOperatorTest: XCTestCase {
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test Cases
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // MARK: Performance test cases
    func testPerformance() {
        let text = "100000"
        self.measure {
            for _ in (0..<1000000) {
                var a: Int?
                a <- text
            }
        }
    }

    func testPerformance2() {
        let text = "RndpQ29yZQ=="
        self.measure {
            for _ in (0..<1000000) {
                var a: Data?
                a <- text
            }
        }
    }
}
