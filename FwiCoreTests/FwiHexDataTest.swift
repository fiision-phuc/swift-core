//  Project name: FwiCore
//  File name   : FwiHexDataTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/23/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


class FwiHexDataTest: XCTestCase {

    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }

    
    // MARK: Test Cases
    func testIsHex() {
        var hexData: NSData? = nil
        XCTAssertNil(hexData?.isHex(), "Nil data should always return nil.")
        
        hexData = "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == false, "Empty data should always return false.")
        
        hexData = "FwiCore".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == false, "Invalid data length should always return false.")
        
        hexData = "つながって".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == false, "Unicode data [つながって] should always return false.")
        
        hexData = "46776943 6f7265".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == false, "46776943 6f7265 is an invalid hex.")
        
        hexData = "467769436f7265".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == true, "467769436f7265 is a valid hex.")
    }
    
    func testDecodeHexData() {
        var hexData: NSData? = nil
        XCTAssertNil(hexData?.decodeHexData(), "Nil data should always return nil.")
        
        hexData = "467769436f7265".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var data = "FwiCore".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(hexData?.decodeHexData() == data, "467769436f7265 should be return as FwiCore after decoded.")
    }
    func testDecodeHexString() {
        var hexData: NSData? = nil
        XCTAssertNil(hexData?.decodeHexString(), "Nil data should always return nil.")
        
        hexData = "467769436f7265".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(hexData?.decodeHexString() == "FwiCore", "467769436f7265 should be return as FwiCore after decoded.")
    }
    
    func testEncodeHexData() {
        var data: NSData? = nil
        XCTAssertNil(data?.encodeHexData(), "Nil data should always return nil.")
        
        data = "FwiCore".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var base64Data = "467769436f7265".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(data?.encodeHexData() == base64Data, "FwiCore should be return as 467769436f7265 after encoded.")
    }
    func testEncodeHexString() {
        var data: NSData? = nil
        XCTAssertNil(data?.encodeHexString(), "Nil data should always return nil.")
        
        data = "FwiCore".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(data?.encodeHexString() == "467769436f7265", "FwiCore should be return as 467769436f7265 after encoded.")
    }
}
