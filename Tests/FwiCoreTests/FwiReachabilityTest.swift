//  Project name: FwiCore
//  File name   : FwiReachabilityTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/18/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import XCTest
import SystemConfiguration
@testable import FwiCore


class FwiReachabilityTest: XCTestCase {
    
    var reachability: FwiReachability?
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test Cases
    func testReachability() {
        _ = expectation(description: "Operation completed.")
        
        reachability = FwiReachability(withHostname: "www.google.com")
        reachability?.start()
        
        waitForExpectations(timeout: 100.0) { [weak self] (err: Error?) in
            XCTAssertNotNil(self?.reachability, "Expected not nil but found: '\(self?.reachability)'")
            self?.reachability?.stop()
        }
    }
    
    func testInternet() {
        let completedExpectation = expectation(description: "Operation completed.")
        reachability = FwiReachability.forInternet()
        XCTAssertNotNil(reachability, "Expected not nil but found: '\(reachability)'")
        
        reachability?.start()
//        reachability?.stop()
        
        waitForExpectations(timeout: 100.0) { (err: Error?) in
            
        }
    }
}
