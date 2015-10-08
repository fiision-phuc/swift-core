//  Project name: FwiCore
//  File name   : FwiOperationTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 1/15/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


class FwiOperationTest: XCTestCase {

    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }
    
    
    // MARK: Test Cases
    func testInitialize() {
        var operation = FwiOperation()
        
        XCTAssertNotNil(operation, "Operation must not be nil.")
        XCTAssertNil(operation.identifier, "Initial operation does not have any identifier.")
        XCTAssertNil(operation.delegate, "Initial operation does not have any delegate.")
        XCTAssertFalse(operation.isLongOperation, "Initial operation is not a long operation.")
        XCTAssertEqual(operation.state, FwiOperationState.Initialize, "Initial operation must be in initial state.")
        
        XCTAssertFalse(operation.finished , "Initial operation is not finished.")
        XCTAssertFalse(operation.cancelled, "Initial operation is not cancelled.")
        XCTAssertFalse(operation.executing, "Initial operation is not executing.")
        XCTAssertTrue(operation.asynchronous, "Initial operation is asynchronous.")
        
        operation.cancel()
        XCTAssertFalse(operation.finished , "Cancelled operation is not finished.")
        XCTAssertTrue(operation.cancelled, "Cancelled operation is cancelled.")
        XCTAssertFalse(operation.executing, "Cancelled operation is not executing.")
        
        XCTAssertNotNil(FwiOperation.getPrivateQueue(), "Operation Queue must not be nil after first initialize an operation.")
    }
    
    func testCompletedOperation() {
        var completedExpectation = self.expectationWithDescription("Operation completed.")
        
        var operation = FwiOperation()
        operation.executeWithCompletion { () -> Void in
            XCTAssertFalse(operation.cancelled, "Initial operation is not cancelled.")
            XCTAssertFalse(operation.executing, "Initial operation is not executing.")
            
            completedExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1.0, handler: { (error: NSError!) -> Void in
            if error == nil {
                XCTAssertTrue(operation.finished, "Operation finished.")
            } else {
                XCTAssertFalse(operation.finished, "Operation could not finish.")
            }
        })
    }
}
