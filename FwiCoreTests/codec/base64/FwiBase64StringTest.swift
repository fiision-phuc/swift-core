//  Project name: FwiCore
//  File name   : FwiBase64StringTest.swift
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


class FwiBase64StringTest: XCTestCase {

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
        var base64String: String? = nil
        XCTAssertNil(base64String?.isBase64(), "Nil data should always return nil.")

        base64String = ""
        XCTAssert(base64String?.isBase64() == false, "Empty data should always return false.")

        base64String = "FwiCore"
        XCTAssert(base64String?.isBase64() == false, "Invalid data length should always return false.")

        base64String = "つながって"
        XCTAssert(base64String?.isBase64() == false, "Unicode data [つながって] should always return false.")

        base64String = "44Gk44Gq4 4GM44Gj44Gm"
        XCTAssert(base64String?.isBase64() == false, "44Gk44Gq4 4GM44Gj44Gm is an invalid base64.")

        base64String = "44Gk44Gq44GM44Gj44Gm"
        XCTAssert(base64String?.isBase64() == true, "44Gk44Gq44GM44Gj44Gm is a valid base64.")

        var base64NSString: NSString? = nil
        XCTAssertNil(base64NSString?.isBase64(), "Nil data should always return nil.")

        base64NSString = ""
        XCTAssert(base64NSString?.isBase64() == false, "Empty data should always return false.")

        base64NSString = "FwiCore"
        XCTAssert(base64NSString?.isBase64() == false, "Invalid data length should always return false.")

        base64NSString = "つながって"
        XCTAssert(base64NSString?.isBase64() == false, "Unicode data [つながって] should always return false.")

        base64NSString = "44Gk44Gq4 4GM44Gj44Gm"
        XCTAssert(base64NSString?.isBase64() == false, "44Gk44Gq44GM44Gj44Gm is a valid base64.")

        base64NSString = "44Gk44Gq44GM44Gj44Gm"
        XCTAssert(base64NSString?.isBase64() == true, "44Gk44Gq44GM44Gj44Gm is a valid base64.")
    }

    func testDecodeBase64Data() {
        var base64String: String? = nil
        XCTAssertNil(base64String?.decodeBase64Data(), "Nil data should always return nil.")

        base64String = "44Gk44Gq44GM44Gj44Gm"
        let data = "つながって".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(base64String?.decodeBase64Data() == data, "44Gk44Gq44GM44Gj44Gm should be return as つながって after decoded.")

        var base64NSString: NSString? = nil
        XCTAssertNil(base64NSString?.decodeBase64Data(), "Nil data should always return nil.")

        base64NSString = "44Gk44Gq44GM44Gj44Gm"
        XCTAssert(base64NSString?.decodeBase64Data() == data, "44Gk44Gq44GM44Gj44Gm should be return as つながって after decoded.")
    }
    func testDecodeBase64String() {
        var base64String: String? = nil
        XCTAssertNil(base64String?.decodeBase64String(), "Nil data should always return nil.")

        base64String = "44Gk44Gq44GM44Gj44Gm"
        XCTAssert(base64String?.decodeBase64String() == "つながって", "44Gk44Gq44GM44Gj44Gm should be return as つながって after decoded.")

        var base64NSString: NSString? = nil
        XCTAssertNil(base64NSString?.decodeBase64String(), "Nil data should always return nil.")

        base64NSString = "44Gk44Gq44GM44Gj44Gm"
        XCTAssert(base64NSString?.decodeBase64String() == "つながって", "44Gk44Gq44GM44Gj44Gm should be return as つながって after decoded.")
    }

    func testEncodeBase64Data() {
        var string: String? = nil
        XCTAssertNil(string?.encodeBase64Data(), "Nil data should always return nil.")

        string = "つながって"
        let base64Data = "44Gk44Gq44GM44Gj44Gm".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(string?.encodeBase64Data() == base64Data, "つながって should be return as 44Gk44Gq44GM44Gj44Gm after encoded.")

        var nsstring: NSString? = nil
        XCTAssertNil(nsstring?.encodeBase64Data(), "Nil data should always return nil.")

        nsstring = "つながって"
        XCTAssert(nsstring?.encodeBase64Data() == base64Data, "つながって should be return as 44Gk44Gq44GM44Gj44Gm after encoded.")
    }
    func testEncodeBase64String() {
        var string: String? = nil
        XCTAssertNil(string?.encodeBase64String(), "Nil data should always return nil.")

        string = "つながって"
        XCTAssert(string?.encodeBase64String() == "44Gk44Gq44GM44Gj44Gm", "つながって should be return as 44Gk44Gq44GM44Gj44Gm after encoded.")

        var nsstring: NSString? = nil
        XCTAssertNil(nsstring?.encodeBase64String(), "Nil data should always return nil.")

        nsstring = "つながって"
        XCTAssert(nsstring?.encodeBase64String() == "44Gk44Gq44GM44Gj44Gm", "つながって should be return as 44Gk44Gq44GM44Gj44Gm after encoded.")
    }
}
