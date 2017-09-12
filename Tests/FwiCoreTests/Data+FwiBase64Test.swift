//  Project name: FwiCore
//  File name   : Data+FwiBase64Test.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/23/14
//  Version     : 1.1.0
//  --------------------------------------------------------------
//  Copyright © 2012, 2017 Fiision Studio.
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


class NSDataFwiBase64Test: XCTestCase {

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
        var base64Data = "FwiCore".toData()
        XCTAssert(base64Data?.isBase64() == false, "Invalid base64 data should always return false.")

        base64Data = "RndpQ29yZQ==".toData()
        XCTAssert(base64Data?.isBase64() == true, "'RndpQ29yZQ==' is a valid base64.")

        let text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        let base64 = text.encodeBase64String()!
        let begin = Date()
        _ = base64.isBase64()
        let end = Date()

        let time = end.timeIntervalSince(end)
        debugPrint(time)
    }

    func testDecodeBase64Data() {
        var base64Data = "FwiCore".toData()
        XCTAssertNil(base64Data?.decodeBase64Data(), "Expected nil data for invalid base64.")

        let data = "FwiCore".toData()
        base64Data = "RndpQ29yZQ==".toData()
        XCTAssertEqual(base64Data?.decodeBase64Data(), data, "Expected 'FwiCore'.")
    }
    func testDecodeBase64String() {
        let base64Data = "RndpQ29yZQ==".toData()
        XCTAssertEqual(base64Data?.decodeBase64String(), "FwiCore", "Expected 'FwiCore'.")
    }

    func testEncodeBase64Data() {
        var data = "".toData()
        XCTAssertNil(data?.encodeBase64Data(), "Empty data should return nil.")

        data = "FwiCore".toData()
        let base64Data = "RndpQ29yZQ==".toData()
        XCTAssertEqual(data?.encodeBase64Data(), base64Data, "Expected 'RndpQ29yZQ=='.")
    }
    func testEncodeBase64String() {
        XCTAssertNil("".toData()?.encodeBase64String(), "Empty string should return nil.")

        let data = "FwiCore".toData()
        XCTAssertEqual(data?.encodeBase64String(), "RndpQ29yZQ==", "Expected 'RndpQ29yZQ=='.")
    }

    // MARK: Performance test cases
    func testIsBase64Performance() {
        let text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        let base64 = text.encodeBase64String()!

        self.measure {
            for _ in (0..<100000) {
                _ = base64.isBase64()
            }
        }
        // Time: 5.189 sec
    }

    func testPerformance() {
        let text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."

        self.measure {
            for _ in (0..<100000) {
                _ = text.encodeBase64String()
            }
        }
    }
}
