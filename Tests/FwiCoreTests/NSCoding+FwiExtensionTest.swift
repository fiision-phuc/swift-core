//  Project name: FwiCore
//  File name   : NSCodingFwiExtensionTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/20/17
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


final class TestNSCoding: NSObject, NSCoding {

    var text: String?

    override init() {
        super.init()
    }

    init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
    }
}


class NSCodingFwiExtensionTest: XCTestCase {
    
    // MARK: Test Cases
    func testReadWriteToUserDefaults() {
        let manager = UserDefaults.standard
        defer {
            manager.removeObject(forKey: "sample")
        }

        let model1 = TestNSCoding()
        model1.text = "FwiCore"

        model1.archive(toUserDefaults: "sample")
        let data1 = manager.object(forKey: "sample") as? Data
        XCTAssertNotNil(data1, "Expected data existed but found: '\(String(describing: data1))'.")

        let model2 = TestNSCoding.unarchive(fromUserDefaults: "sample")
        XCTAssertNotNil(model2, "Expected model2 must not be nil.")
        XCTAssertEqual(model2?.text ?? "", "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model2?.text)).")
    }

    func testReadWriteToFile() {
        guard let url = URL.documentDirectory()?.appendingPathComponent("sample") else {
            XCTFail("Could not create url.")
            return
        }

        let manager = FileManager.`default`
        defer {
            manager.removeFile(atURL: url)
        }

        let model1 = TestNSCoding()
        model1.text = "FwiCore"

        model1.archive(toFile: url)
        XCTAssertTrue(manager.fileExists(atURL: url), "Expected file existed at: '\(url.absoluteString)'.")

        let model2 = TestNSCoding.unarchive(fromFile: url)
        XCTAssertNotNil(model2, "Expected model2 must not be nil.")
        XCTAssertEqual(model2?.text ?? "", "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model2?.text)).")
    }
}
