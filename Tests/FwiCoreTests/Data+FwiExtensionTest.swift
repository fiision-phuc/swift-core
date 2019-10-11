//  Project name: FwiCore
//  File name   : Data+FwiExtensionTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/27/14
//  Version     : 2.0.0
//  --------------------------------------------------------------
//  Copyright © 2012, 2019 Fiision Studio. All Rights Reserved.
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

class DataFwiExtensionTest: XCTestCase {

    // MARK: Test Cases
    func testClearBytes() {
        FwiCore.debug = true
        var data1 = Data([0x40, 0x41, 0x42])
        let data2 = Data([0x00, 0x00, 0x00])

        data1.clearBytes()
        XCTAssertEqual(data1, data2, "Data1 should contain all zero.")
    }

    func testReverseBytes() {
        var data1 = Data([0x40, 0x41, 0x42])
        var data2 = Data([0x42, 0x41, 0x40])
        data1.reverseBytes()
        XCTAssertEqual(data1, data2, "Data1 should be reversed.")

        data1 = Data([0x40, 0x41, 0x42, 0x43])
        data2 = Data([0x43, 0x42, 0x41, 0x40])
        data1.reverseBytes()
        XCTAssertEqual(data1, data2, "Data1 should be reversed.")
    }

    func testToString() {
        guard let data = "FwiCore".data(using: String.Encoding.utf8, allowLossyConversion: false), let text = data.toString() else {
            XCTFail("Could not convert string to data.")
            return
        }
        XCTAssertEqual(text, "FwiCore", "Expected 'FwiCore' but found '\(text)'.")
    }

    func testReadWriteToFile() {
        guard let data1 = "FwiCore".toData(), let url = URL.cacheDirectory()?.appendingPathComponent("sample") else {
            XCTFail("Could not convert string to data.")
            return
        }

        let manager = FileManager.default
        defer {
            try? manager.removeFile(url)
        }

        try? data1.write(url, writingMode: .atomic)
        XCTAssertTrue(manager.fileExists(url), "Expected file existed at: '\(url.absoluteString)'.")

        let data2 = try? Data.read(url)
        XCTAssertNotNil(data2, "Expected data2 must not be nil.")
        XCTAssertEqual(data2, data1, "Expected data2 must be equal data1.")
    }
}
