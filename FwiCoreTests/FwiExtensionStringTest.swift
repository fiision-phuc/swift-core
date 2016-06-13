//  Project name: FwiCore
//  File name   : FwiExtensionStringTest.swift
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


class FwiExtensionStringTest: XCTestCase {
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }
    
    
    // MARK: Test Cases
    func testIsEqualToStringIgnoreCase() {
        var text1: String? = nil
        var text2: String? = nil
        XCTAssert(text1?.isEqualToStringIgnoreCase(text2) == nil, "Nil data should always return nil.")
        text1 = "FWICORE"
        XCTAssertFalse(text1!.isEqualToStringIgnoreCase(text2), "Always return false when compare to nil value.")
        text2 = "fwicore"
        XCTAssertTrue(text1!.isEqualToStringIgnoreCase(text2), "FWICORE compares with fwicore should return true.")
        
        
        var text3: NSString? = nil
        var text4: NSString? = nil
        XCTAssert(text3?.isEqualToStringIgnoreCase(text4 as? String) == nil, "Nil data should always return nil.")
        text3 = "FWICORE"
        XCTAssertFalse(text3!.isEqualToStringIgnoreCase(text4 as? String), "Always return false when compare to nil value.")
        text4 = "fwicore"
        XCTAssertTrue(text3!.isEqualToStringIgnoreCase(text4 as? String), "FWICORE compares with fwicore should return true.")
    }
    
    func testMatchPattern() {
        var text1: String? = nil
        XCTAssert(text1?.matchPattern("^\\d+$") == nil, "Nil data should always return nil.")
        text1 = " 12345 "
        XCTAssertFalse(text1!.matchPattern("^\\d+$"), "\(text1) is invalid input.")
        text1 = "12345"
        XCTAssertTrue(text1!.matchPattern("^\\d+$"), "\(text1) is invalid input.")
        
        
        var text2: NSString? = nil
        XCTAssert(text2?.matchPattern("^\\d+$") == nil, "Nil data should always return nil.")
        text2 = " 12345 "
        XCTAssertFalse(text2!.matchPattern("^\\d+$"), "\(text2) is invalid input.")
        text2 = "12345"
        XCTAssertTrue(text2!.matchPattern("^\\d+$"), "\(text2) is invalid input.")
    }
    
    func testDecodeHTML() {
        var text1: String? = nil
        XCTAssert(text1?.decodeHTML() == nil, "Nil data should always return nil.")
        text1 = "Functional%20Fwicore"
        XCTAssertEqual(text1!.decodeHTML()!, "Functional Fwicore", "\(text1) should become Functional Fwicore after decoded.")
        
        
        var text2: NSString? = nil
        XCTAssert(text2?.decodeHTML() == nil, "Nil data should always return nil.")
        text2 = "Functional%20Fwicore"
        XCTAssertEqual(text2!.decodeHTML()!, "Functional Fwicore", "\(text2) should become Functional Fwicore after decoded.")
    }
    
    func testEncodeHTML() {
        var text1: String? = nil
        XCTAssert(text1?.encodeHTML() == nil, "Nil data should always return nil.")
        text1 = "Functional Fwicore"
        XCTAssertEqual(text1!.encodeHTML()!, "Functional%20Fwicore", "\(text1) should become Functional%20Fwicore after encoded.")
        
        
        var text2: NSString? = nil
        XCTAssert(text2?.encodeHTML() == nil, "Nil data should always return nil.")
        text2 = "Functional Fwicore"
        XCTAssertEqual(text2!.encodeHTML()!, "Functional%20Fwicore", "\(text2) should become Functional%20Fwicore after encoded.")
    }
    
    func testSplitWithSeparator() {
        var text1: String? = nil
        XCTAssert(text1?.split("/") == nil, "Nil data should always return nil.")
        text1 = "FwiCore/FWICORE"
        XCTAssertEqual(text1!.split("/")!, ["FwiCore", "FWICORE"], "\(text1) should become array after split.")
        
        
        var text2: NSString? = nil
        XCTAssert(text2?.split("/") == nil, "Nil data should always return nil.")
        text2 = "FwiCore/FWICORE"
        XCTAssertEqual(text2!.split("/")!, ["FwiCore", "FWICORE"], "\(text2) should become array after split.")
    }
    
    func testTrim() {
        var text1: String? = nil
        XCTAssert(text1?.trim() == nil, "Nil data should always return nil.")
        text1 = " FwiCore "
        XCTAssertEqual(text1!.trim()!, "FwiCore", "\(text1) should become FwiCore after trim.")
        
        
        var text2: NSString? = nil
        XCTAssert(text2?.trim() == nil, "Nil data should always return nil.")
        text2 = " FwiCore "
        XCTAssertEqual(text2!.trim()!, "FwiCore", "\(text2) should become FwiCore after trim.")
    }
}
