//  Project name: FwiCore
//  File name   : URL+FwiExtensionTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/26/16
//  Version     : 2.0.0
//  --------------------------------------------------------------
//  Copyright © 2012, 2018 Fiision Studio. All Rights Reserved.
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


class URLFwiExtensionTest: XCTestCase {
    
    // MARK: Test Cases
    func testOperatorPlusPath() {
        var url = URL(string: "https://google.com")
        var p: String? = nil
        var url1 = url + p
        if let path = url1?.absoluteString {
            XCTAssertEqual(path, "https://google.com", "Expected 'https://google.com' but found '\(path)'.")
        } else {
            XCTFail("Invalid url.")
        }
        
        p = "/get"
        url1 = url + p
        if let path = url1?.absoluteString {
            XCTAssertEqual(path, "https://google.com/get", "Expected 'https://google.com' but found '\(path)'.")
        } else {
            XCTFail("Invalid url.")
        }
        
        url += "/get"
        if let path = url?.absoluteString {
            XCTAssertEqual(path, "https://google.com/get", "Expected 'https://google.com' but found '\(path)'.")
        } else {
            XCTFail("Invalid url.")
        }
    }
    
//    func testOperatorPlusParams() {
//        var url = URL(string: "https://google.com")
//        var params: [String:String]? = nil
//        var url1 = url + params
//        if let path = url1?.absoluteString {
//            XCTAssertEqual(path, "https://google.com", "Expected 'https://google.com' but found '\(path)'.")
//        } else {
//            XCTFail("Invalid url.")
//        }
//        
//        params = ["string1":"value1", "string2":"value2"]
//        url1 = url + params
//        if let path = url1?.absoluteString {
//            XCTAssertEqual(path, "https://google.com?string1=value1&string2=value2", "Expected 'https://google.com?string1=value1&string2=value2' but found '\(path)'.")
//        } else {
//            XCTFail("Invalid url.")
//        }
//        
//        params = ["#string1":"value1", "string2":"value2", "string3":"value3"]
//        url1 = url + params
//        if let path = url1?.absoluteString {
//            XCTAssertEqual(path, "https://google.com#string1=value1?string2=value2&string3=value3", "Expected 'https://google.com#string1=value1?string2=value2&string3=value3' but found '\(path)'.")
//        } else {
//            XCTFail("Invalid url.")
//        }
//        
//        params = ["string1":"value1", "#string2":"value2", "string3":"value3"]
//        url1 = url + params
//        if let path = url1?.absoluteString {
//            XCTAssertEqual(path, "https://google.com#string2=value2?string1=value1&string3=value3", "Expected 'https://google.com#string2=value2?string1=value1&string3=value3' but found '\(path)'.")
//        } else {
//            XCTFail("Invalid url.")
//        }
//        
//        params = ["#string2":"value2", "#string1":"value1", "string3":"value3"]
//        url1 = url + params
//        if let path = url1?.absoluteString {
//            XCTAssertEqual(path, "https://google.com#string1=value1?string3=value3", "Expected 'https://google.com#string1=value1?string3=value3' but found '\(path)'.")
//        } else {
//            XCTFail("Invalid url.")
//        }
//        
//        // Case Empty Query
//        params = ["#string1":"value1"]
//        url1 = url + params
//        if let path = url1?.absoluteString {
//            XCTAssertEqual(path,"https://google.com#string1=value1","Expected 'https://google.com#string1=value1'  but found '\(path)'.")
//        } else {
//            XCTFail("Invalid url.")
//        }
//        
//        params = ["#string1":"value1", "string2":"value2", "string3":"value3"]
//        url += params
//        if let path = url?.absoluteString {
//            XCTAssertEqual(path, "https://google.com#string1=value1?string2=value2&string3=value3", "Expected 'https://google.com#string1=value1?string2=value2&string3=value3' but found '\(path)'.")
//        } else {
//            XCTFail("Invalid url.")
//        }
//    }
}
