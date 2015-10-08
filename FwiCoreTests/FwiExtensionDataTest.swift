//  Project name: FwiCore
//  File name   : FwiExtensionDataTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/27/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


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
        var bytes1: [UInt8] = [0x40,0x41,0x42]
        var bytes2: [UInt8] = [0x00,0x00,0x00]
        var data1: NSData = NSData(bytes: bytes1, length: 3)
        var data2: NSData = NSData(bytes: bytes2, length: 3)
        
        data1.clearBytes()
        XCTAssertEqual(data1, data2, "Data1 should contain all zero.")
    }
    
    func testReverseBytes() {
        var bytes1: [UInt8] = [0x40,0x41,0x42]
        var bytes2: [UInt8] = [0x42,0x41,0x40]
        var data1: NSData = NSData(bytes: bytes1, length: 3)
        var data2: NSData = NSData(bytes: bytes2, length: 3)
        
        data1.reverseBytes()
        XCTAssertEqual(data1, data2, "Data1 should be reversed.")
    }
}
