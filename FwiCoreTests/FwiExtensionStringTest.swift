//  Project name: FwiCore
//  File name   : FwiExtensionStringTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/27/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


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
        XCTAssert(text1?.splitWithSeparator("/") == nil, "Nil data should always return nil.")
        text1 = "FwiCore/FWICORE"
        XCTAssertEqual(text1!.splitWithSeparator("/")!, ["FwiCore", "FWICORE"], "\(text1) should become array after split.")
        
        
        var text2: NSString? = nil
        XCTAssert(text2?.splitWithSeparator("/") == nil, "Nil data should always return nil.")
        text2 = "FwiCore/FWICORE"
        XCTAssertEqual(text2!.splitWithSeparator("/")!, ["FwiCore", "FWICORE"], "\(text2) should become array after split.")
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
