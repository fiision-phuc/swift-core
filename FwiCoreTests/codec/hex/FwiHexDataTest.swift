//  Project name: FwiCore
//  File name   : FwiHexDataTest.swift
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

import XCTest
@testable import FwiCore


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
        var hexData: Data? = nil
        XCTAssertNil(hexData?.isHex(), "Nil data should always return nil.")

        hexData = "".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == false, "Empty data should always return false.")

        hexData = "FwiCore".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == false, "Invalid data length should always return false.")

        hexData = "つながって".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == false, "Unicode data [つながって] should always return false.")

        hexData = "46776943 6f7265".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == false, "46776943 6f7265 is an invalid hex.")

        hexData = "467769436f7265".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(hexData?.isHex() == true, "467769436f7265 is a valid hex.")
    }

    func testDecodeHexData() {
        var hexData: Data? = nil
        XCTAssertNil(hexData?.decodeHexData(), "Nil data should always return nil.")

        hexData = "467769436f7265".data(using: String.Encoding.utf8, allowLossyConversion: false)
        let data = "FwiCore".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(hexData?.decodeHexData() == data, "467769436f7265 should be return as FwiCore after decoded.")
    }
    func testDecodeHexString() {
        var hexData: Data? = nil
        XCTAssertNil(hexData?.decodeHexString(), "Nil data should always return nil.")

        hexData = "467769436f7265".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(hexData?.decodeHexString() == "FwiCore", "467769436f7265 should be return as FwiCore after decoded.")
    }

    func testEncodeHexData() {
        var data: Data? = nil
        XCTAssertNil(data?.encodeHexData(), "Nil data should always return nil.")

        data = "FwiCore".data(using: String.Encoding.utf8, allowLossyConversion: false)
        let base64Data = "467769436f7265".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(data?.encodeHexData() == base64Data, "FwiCore should be return as 467769436f7265 after encoded.")
    }
    func testEncodeHexString() {
        var data: Data? = nil
        XCTAssertNil(data?.encodeHexString(), "Nil data should always return nil.")

        data = "FwiCore".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(data?.encodeHexString() == "467769436f7265", "FwiCore should be return as 467769436f7265 after encoded.")
    }
}
