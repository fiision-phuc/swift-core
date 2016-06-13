//  Project name: FwiCore
//  File name   : FwiHexStringTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/23/14
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

import UIKit
import XCTest
@testable import FwiCore


class FwiHexStringTest: XCTestCase {

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
        var hexString: String? = nil
        XCTAssertNil(hexString?.isHex(), "Nil data should always return nil.")
        
        hexString = ""
        XCTAssert(hexString?.isHex() == false, "Empty data should always return false.")
        
        hexString = "FwiCore"
        XCTAssert(hexString?.isHex() == false, "Invalid data length should always return false.")
        
        hexString = "つながって"
        XCTAssert(hexString?.isHex() == false, "Unicode data [つながって] should always return false.")
        
        hexString = "46776943 6f7265"
        XCTAssert(hexString?.isHex() == false, "46776943 6f7265 is an invalid hex.")
        
        hexString = "467769436f7265"
        XCTAssert(hexString?.isHex() == true, "467769436f7265 is a valid hex.")
        
        var hexNSString: NSString? = nil
        XCTAssertNil(hexNSString?.isHex(), "Nil data should always return nil.")
        
        hexNSString = ""
        XCTAssert(hexNSString?.isHex() == false, "Empty data should always return false.")
        
        hexNSString = "FwiCore"
        XCTAssert(hexNSString?.isHex() == false, "Invalid data length should always return false.")
        
        hexNSString = "つながって"
        XCTAssert(hexNSString?.isHex() == false, "Unicode data [つながって] should always return false.")
        
        hexNSString = "46776943 6f7265"
        XCTAssert(hexNSString?.isHex() == false, "46776943 6f7265 is a valid hex.")
        
        hexNSString = "467769436f7265"
        XCTAssert(hexNSString?.isHex() == true, "467769436f7265 is a valid hex.")
    }
    
    func testDecodeHexData() {
        var hexString: String? = nil
        XCTAssertNil(hexString?.decodeHexData(), "Nil data should always return nil.")
        
        hexString = "467769436f7265"
        var data = "FwiCore".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(hexString?.decodeHexData() == data, "467769436f7265 should be return as FwiCore after decoded.")
        
        var base64NSString: NSString? = nil
        XCTAssertNil(base64NSString?.decodeHexData(), "Nil data should always return nil.")
        
        base64NSString = "467769436f7265"
        XCTAssert(base64NSString?.decodeHexData() == data, "467769436f7265 should be return as FwiCore after decoded.")
    }
    func testDecodeHexString() {
        var hexString: String? = nil
        XCTAssertNil(hexString?.decodeHexString(), "Nil data should always return nil.")
        
        hexString = "467769436f7265"
        XCTAssert(hexString?.decodeHexString() == "FwiCore", "467769436f7265 should be return as FwiCore after decoded.")
        
        var base64NSString: NSString? = nil
        XCTAssertNil(base64NSString?.decodeHexString(), "Nil data should always return nil.")
        
        base64NSString = "467769436f7265"
        XCTAssert(base64NSString?.decodeHexString() == "FwiCore", "467769436f7265 should be return as FwiCore after decoded.")
    }
    
    func testEncodeHexData() {
        var string: String? = nil
        XCTAssertNil(string?.encodeHexString(), "Nil data should always return nil.")
        
        string = "FwiCore"
        var base64Data = "467769436f7265".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        XCTAssert(string?.encodeHexData() == base64Data, "FwiCore should be return as 467769436f7265 after encoded.")
        
        var nsstring: NSString? = nil
        XCTAssertNil(nsstring?.encodeHexData(), "Nil data should always return nil.")
        
        nsstring = "FwiCore"
        XCTAssert(nsstring?.encodeHexData() == base64Data, "FwiCore should be return as 467769436f7265 after encoded.")
    }
    func testEncodeHexString() {
        var string: NSString? = nil
        XCTAssertNil(string?.encodeHexString(), "Nil data should always return nil.")
        
        string = "FwiCore"
        XCTAssert(string?.encodeHexString() == "467769436f7265", "FwiCore should be return as 467769436f7265 after encoded.")
        
        var nsstring: NSString? = nil
        XCTAssertNil(nsstring?.encodeHexString(), "Nil data should always return nil.")
        
        nsstring = "FwiCore"
        XCTAssert(nsstring?.encodeHexString() == "467769436f7265", "FwiCore should be return as 467769436f7265 after encoded.")
    }
}
