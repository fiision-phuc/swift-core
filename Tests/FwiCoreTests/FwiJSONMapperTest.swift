//  Project name: FwiCore
//  File name   : FwiJSONMapperTest.swift
//
//  Author      : Dung Vu
//  Created date: 6/14/16
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


class URLTest: NSObject {
    var url: URL?
}

class Test: NSObject, FwiJSONModel {

    var a: Int = 0
    var z: URLTest?
    var d: [String: AnyObject]?
//    var m: [String: URLTest]?
    var arr: [URLTest]?
    var arrNormal: [Int]?
    var arrString: [String]?
    var date: Date?
    var dateStr: Date?

    func keyMapper() -> [String : String] {
        return ["test1":"a",
                "test2":"z",
                "test3":"d",
                "test4":"m",
                "test5":"arr",
                "test6":"arrNormal",
                "test7":"arrString",
                "test8":"date" ,
                "test9":"dateStr"
        ]
    }


}

class TestJSON1: NSObject {

    var a: Int = 0
    var b: Float = 0
    var c: Double = 0
    var d: String = ""

    var e: UInt = 0
    var f: Float = 0
}

class TestJSON2: NSObject {

    var a: Int?
    var b: Float?
    var c: Double?
    var d: String?

    var e: UInt?
    var f: Float?
    var g: Double?
}

class TestJSON3: TestJSON1 {

    var url: URL?
    var data1: Data?
    var data2: Data?
    var date1: Date?
    var date2: Date?
}

class FwiJSONMapperTest: XCTestCase {

    // MARK: Setup
    override func setUp() {
        super.setUp()
    }

    // MARK: Teardown
    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test cases
    func testMapDictionaryToNonOptionalProperties() {
        let d: [String : Any] = ["a":NSNumber(value: 1), "b":NSNumber(value: 2), "c":NSNumber(value: 3), "d":"Hello world", "e":"10", "f":"10.15"]
        let (o, _) = FwiJSONMapper().mapDictionary(dictionary: d, toModel: TestJSON1.self)

        guard let model = o else {
            XCTFail("Expected o is not null.")
            return
        }
        XCTAssertEqual(model.a, 1, "Expected '1' but found: '\(model.a)'.")
        XCTAssertEqual(model.b, 2, "Expected '2' but found: '\(model.b)'.")
        XCTAssertEqual(model.c, 3, "Expected '3' but found: '\(model.c)'.")
        XCTAssertEqual(model.e, 10, "Expected '10' but found: '\(model.e)'.")
        XCTAssertEqual(model.d, "Hello world", "Expected 'Hello world' but found: '\(model.d)'.")
    }

    func testMapDictionaryToOptionalProperties() {
        let d: [String : Any] = ["a":NSNumber(value: 1), "b":NSNumber(value: 2), "c":NSNumber(value: 3), "d":"Hello world", "e":"10", "f":"10.15"]
        let (o, _) = FwiJSONMapper().mapDictionary(dictionary: d, toModel: TestJSON2.self)

        guard let model = o else {
            XCTFail("Expected o is not null.")
            return
        }
        XCTAssertEqual(model.a, 1, "Expected '1' but found: '\(model.a)'.")
        XCTAssertEqual(model.b, 2, "Expected '2' but found: '\(model.b)'.")
        XCTAssertEqual(model.c, 3, "Expected '3' but found: '\(model.c)'.")
        XCTAssertEqual(model.e, 10, "Expected '10' but found: '\(model.e)'.")
        XCTAssertEqual(model.d, "Hello world", "Expected 'Hello world' but found: '\(model.d)'.")
        XCTAssertNil(model.g, "Expected nil but found: '\(model.g)'.")
    }

    func testMapDictionary() {
        let d: [String : Any] = ["a":NSNumber(value: 1),
                                 "b":NSNumber(value: 2),
                                 "c":NSNumber(value: 3),
                                 "d":"Hello world",
                                 "e":"10",
                                 "f":"10.15",
                                 "url": "https://www.google.com/?gws_rd=ssl",
                                 "data1": "RndpQ29yZQ==",
                                 "data2": "2012-04-23T18:25:43.511Z",
                                 "date1": 1464768697,
                                 "date2": "2012-04-23T18:25:43.511Z"]
        let (o, _) = FwiJSONMapper().mapDictionary(dictionary: d, toModel: TestJSON3.self)

        guard let model = o else {
            XCTFail("Expected o is not null.")
            return
        }
        XCTAssertEqual(model.a, 1, "Expected '1' but found: '\(model.a)'.")
        XCTAssertEqual(model.b, 2, "Expected '2' but found: '\(model.b)'.")
        XCTAssertEqual(model.c, 3, "Expected '3' but found: '\(model.c)'.")
        XCTAssertEqual(model.e, 10, "Expected '10' but found: '\(model.e)'.")

        XCTAssertEqual(model.d, "Hello world", "Expected 'Hello world' but found: '\(model.d)'.")
        XCTAssertNotNil(model.url, "Expected not nil but found: '\(model.url)'.")
        XCTAssertEqual(model.url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(model.url?.absoluteString)'.")
        XCTAssertNotNil(model.data1, "Expected not nil but found: '\(model.data1)'.")
        XCTAssertNotNil(model.data2, "Expected not nil but found: '\(model.data2)'.")
        XCTAssertNotNil(model.date1, "Expected not nil but found: '\(model.date1)'.")
        XCTAssertNotNil(model.date2, "Expected not nil but found: '\(model.date2)'.")
    }



    func testExample() {
        let dict = ["test1": 5,
                    "test2": ["url": "https://www.google.com/?gws_rd=ssl"],
                    "test3" : ["testDict" : "abc"],
//                    "test4": ["key" : ["url": "https://www.google.com/?gws_rd=ssl"]],
                    "test5": [["url": "https://www.google.com/?gws_rd=ssl"],
                        ["url": "https://www.google.com/?gws_rd=ssl"],
                        ["url": "https://www.google.com/?gws_rd=ssl"]],
                    "test6": [2, 4, 6],
                    "test7": ["adad", "dadada", "duadgaud"],
                    "test8": 1464768697,
                    "test9": "2012-10-01T094500GMT"

        ] as [String : Any]

//        let c = JSONMapper1.mapClassWithDictionary(Test.self, dict: dict).object

        var c = Test()
//        FwiJSONMapper().mapDictionary(dictionary: dict, toModel: &c)
        let error = FwiJSONMapper.mapObjectToModel(dict, model: &c)


        let dict1 = FwiJSONMapper.toDictionary(c)
        print(dict1)

    }

}
