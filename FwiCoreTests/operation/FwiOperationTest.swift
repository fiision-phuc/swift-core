//  Project name: FwiCore
//  File name   : FwiOperationTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 1/15/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2012, 2016 Fiision Studio.
//  All Rights Reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Fiision Studio disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import XCTest
@testable import FwiCore


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
        let operation = FwiOperation()

        XCTAssertNotNil(operation, "Operation must not be nil.")
        XCTAssertNil(operation.identifier, "Initial operation does not have any identifier.")
        XCTAssertFalse(operation.isLongOperation, "Initial operation is not a long operation.")

        XCTAssertFalse(operation.isFinished, "Initial operation is not finished.")
        XCTAssertFalse(operation.isCancelled, "Initial operation is not cancelled.")
        XCTAssertFalse(operation.isExecuting, "Initial operation is not executing.")
        XCTAssertTrue(operation.isAsynchronous, "Initial operation is asynchronous.")

        operation.cancel()
        XCTAssertFalse(operation.isFinished, "Cancelled operation is not finished.")
        XCTAssertTrue(operation.isCancelled, "Cancelled operation is cancelled.")
        XCTAssertFalse(operation.isExecuting, "Cancelled operation is not executing.")

        XCTAssertNotNil(operationQueue, "Operation Queue must not be nil after first initialize an operation.")
    }

    func testCompletedOperation() {
        let completedExpectation = self.expectation(description: "Operation completed.")

        let operation = FwiOperation()
        operation.executeWithCompletion { () -> Void in
            XCTAssertFalse(operation.isCancelled, "Initial operation is not cancelled.")
            XCTAssertFalse(operation.isExecuting, "Initial operation is not executing.")

            completedExpectation.fulfill()
        }

        
        self.waitForExpectations(timeout: 1.0) { (err: Error?) in
            if err == nil {
                XCTAssertTrue(operation.isFinished, "Operation finished.")
            } else {
                XCTAssertFalse(operation.isFinished, "Operation could not finish.")
            }
        }
    }
}
