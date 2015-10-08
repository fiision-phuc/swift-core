//  Project name: FwiCore
//  File name   : FwiBase64DataTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/23/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


class FwiBase64DataTest: XCTestCase {

    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }
    
    
    // MARK: Test Cases
    func testIsBase64() {
        var base64Data: NSData? = nil
        XCTAssertNil(base64Data?.isBase64(), "Nil data should always return nil.")
        
        base64Data = "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(base64Data?.isBase64() == false, "Empty data should always return false.")
        
        base64Data = "FwiCore".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(base64Data?.isBase64() == false, "Invalid data length should always return false.")
        
        base64Data = "つながって".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(base64Data?.isBase64() == false, "Unicode data [つながって] should always return false.")
        
        base64Data = "44Gk44Gq4 4GM44Gj44Gm".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(base64Data?.isBase64() == false, "44Gk44Gq4 4GM44Gj44Gm is an invalid base64.")
        
        base64Data = "44Gk44Gq44GM44Gj44Gm".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(base64Data?.isBase64() == true, "44Gk44Gq44GM44Gj44Gm is a valid base64.")
    }
    
    func testDecodeBase64Data() {
        var base64Data: NSData? = nil
        XCTAssertNil(base64Data?.decodeBase64Data(), "Nil data should always return nil.")
        
        base64Data = "44Gk44Gq44GM44Gj44Gm".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var data = "つながって".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(base64Data?.decodeBase64Data() == data, "44Gk44Gq44GM44Gj44Gm should be return as つながって after decoded.")
    }
    func testDecodeBase64String() {
        var base64Data: NSData? = nil
        XCTAssertNil(base64Data?.decodeBase64String(), "Nil data should always return nil.")

        base64Data = "44Gk44Gq44GM44Gj44Gm".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(base64Data?.decodeBase64String() == "つながって", "44Gk44Gq44GM44Gj44Gm should be return as つながって after decoded.")
    }
    
    func testEncodeBase64Data() {
        var data: NSData? = nil
        XCTAssertNil(data?.encodeBase64Data(), "Nil data should always return nil.")
        
        data = "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssertNil(data?.encodeBase64Data(), "Empty data should return nil.")
        XCTAssertNil(data?.encodeBase64String(), "Empty data should return nil.")
        
        data = "つながって".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var base64Data = "44Gk44Gq44GM44Gj44Gm".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(data?.encodeBase64Data() == base64Data, "つながって should be return as 44Gk44Gq44GM44Gj44Gm after encoded.")
    }
    func testEncodeBase64String() {
        var data: NSData? = nil
        XCTAssertNil(data?.encodeBase64String(), "Nil data should always return nil.")
        
        XCTAssertNil("".encodeBase64Data(), "Empty string should return nil.")
        XCTAssertNil("".encodeBase64String(), "Empty string should return nil.")
        
        data = "つながって".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(data?.encodeBase64String() == "44Gk44Gq44GM44Gj44Gm", "つながって should be return as 44Gk44Gq44GM44Gj44Gm after encoded.")
    }
}
