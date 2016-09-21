//  Project name: FwiCore
//  File name   : FwiPersistentManagerTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/21/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import XCTest
@testable import FwiCore


class FwiPersistentManagerTest: XCTestCase {
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test Cases
    func testInit() {
        let persistent = FwiPersistentManager(withModel: "Sample", fromBundle: Bundle(for: FwiPersistentManagerTest.self), storeType: .memory)

        XCTAssertNotNil(persistent, "Expected not nil but found '\(persistent)'.")
        XCTAssertNotNil(persistent.managedContext, "Expected not nil but found '\(persistent.managedContext)'.")
        XCTAssertNotNil(persistent.managedModel, "Expected not nil but found '\(persistent.managedModel)'.")
        XCTAssertNotNil(persistent.persistentCoordinator, "Expected not nil but found '\(persistent.persistentCoordinator)'.")
    }
    
    // MARK: Performance test cases
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
