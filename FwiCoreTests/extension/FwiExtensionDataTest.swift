// Project name: FwiCore
//  File name   : FwiExtensionDataTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/27/14
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

class FwiExtensionDataTest: XCTestCase {

    // MARK: Setup
    override func setUp() {
        super.setUp()
    }

    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test Cases
    func testToString() {
        var data: NSData? = nil
        XCTAssertNil(data?.toString(), "Nil data should always return nil.")

        data = "FwiCore".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssertEqual(data!.toString()!, "FwiCore", "Data should return FwiCore.")
    }

    func testClearBytes() {
        var bytes1: [UInt8] = [0x40, 0x41, 0x42]
        var bytes2: [UInt8] = [0x00, 0x00, 0x00]
        var data1: NSData = NSData(bytes: bytes1, length: 3)
        var data2: NSData = NSData(bytes: bytes2, length: 3)

        data1.clearBytes()
        XCTAssertEqual(data1, data2, "Data1 should contain all zero.")
    }

    func testReverseBytes() {
        var bytes1: [UInt8] = [0x40, 0x41, 0x42]
        var bytes2: [UInt8] = [0x42, 0x41, 0x40]
        var data1: NSData = NSData(bytes: bytes1, length: 3)
        var data2: NSData = NSData(bytes: bytes2, length: 3)

        data1.reverseBytes()
        XCTAssertEqual(data1, data2, "Data1 should be reversed.")
    }
}
