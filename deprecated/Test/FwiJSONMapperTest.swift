//  Project name: FwiCore
//  File name   : FwiJSONMapperTest.swift
//
//  Author      : Dung Vu
//  Created date: 6/14/16
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


class URLTest: FwiJSONModel {

    var url: URL?
    
    required init(withJSON json: JSON) {
        url <- json["url"]
    }
}

struct TestJSON1: FwiJSONModel {

    var aBool: Bool = false

    var a: Int    = 0
    var b: Int8   = 0
    var c: Int16  = 0
    var d: Int32  = 0
    var e: Int64  = 0

    var f: UInt   = 0
    var g: UInt8  = 0
    var h: UInt16 = 0
    var i: UInt32 = 0
    var j: UInt64 = 0

    var k: Float  = 0
    var l: Double = 0
    var m: String = ""

    init(withJSON json: JSON) {
        aBool <- json["aBool"]

        a <- json["a"]
        b <- json["a"]
        c <- json["a"]
        d <- json["a"]
        e <- json["a"]

        f <- json["b"]
        g <- json["b"]
        h <- json["b"]
        i <- json["b"]
        j <- json["b"]

        k <- json["c"]
        l <- json["d"]
        m <- json["e"]
    }
}

struct TestJSON2: FwiJSONModel {

    var aBool: Bool?

    var a: Int?
    var b: Int8?
    var c: Int16?
    var d: Int32?
    var e: Int64?

    var f: UInt?
    var g: UInt8?
    var h: UInt16?
    var i: UInt32?
    var j: UInt64?

    var k: Float?
    var l: Double?
    var m: String?

    init(withJSON json: JSON) {
        aBool <- json["aBool"]

        a <- json["a"]
        b <- json["a"]
        c <- json["a"]
        d <- json["a"]
        e <- json["a"]

        f <- json["b"]
        g <- json["b"]
        h <- json["b"]
        i <- json["b"]
        j <- json["b"]

        k <- json["c"]
        l <- json["d"]
        m <- json["e"]
    }
}

struct TestJSON3: FwiJSONModel {

    var url: URL?
    var date: Date?
    var data1: Data?
    var data2: Data?
    var urlTest: URLTest?

    init(withJSON json: JSON) {
        url <- json["url"]
        date <- json["date"]
        data1 <- json["data1"]
        data2 <- json["data2"]
        urlTest <- json["url_test"]
    }
}

struct TestJSON4: FwiJSONModel {

    var array: [URLTest]?

    var arrayInt1: [Int]?
    var arrayString1: [String]?

    var arrayInt2: [Int]?
    var arrayString2: [String]?

    var arrayAny1: [Any]?
    var arrayAny2: [Any]?

    var arrayUrls: [URL]?

    init(withJSON json: JSON) {
        array <- json["array"]

        arrayInt1 <- json["arrayInt1"]
        arrayString1 <- json["arrayString1"]

        arrayInt2 <- json["arrayInt2"]
        arrayString2 <- json["arrayString2"]

        arrayAny1 <- json["arrayAny1"]
        arrayAny2 <- json["arrayAny2"]
        
        arrayUrls <- json["arrayUrls"]
    }
}

struct TestJSON5: FwiJSONModel {

    var urls1: [String:String]?
    var urls2: [String:URL]?
    var urls3: [String:Int]?
    var urls4: [String:Int]?
    var urls5: [String:Int]?
    var urlTest: URLTest?

    init(withJSON json: JSON) {
        urls1 <- json["urls1"]
        urls2 <- json["urls2"]
        urls3 <- json["urls3"]
        urls4 <- json["urls4"]
        urls5 <- json["urls5"]
        urlTest <- json["urlTest"]
    }
}

struct TestJSON6: FwiJSONModel {
    
    var a: Int = 0
    var z: URLTest?
    var d: [String: Any]?
    var arr: [URLTest]?
    var arrNormal: [Int]?
    var arrString: [String]?
    var date: Date?
    var dateStr: Date?

    init(withJSON json: JSON) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HHmmss'GMT'"

        a <- json["test1"]
        z <- json["test2"]
        d <- json["test3"]
        arr <- json["test4"]
        arrNormal <- json["test5"]
        arrString <- json["test6"]
        date <- json["test7"]
        dateStr = df <- json["test8"]
    }
}

class TestJSON7: FwiJSONModel {

    var test: URLTest?

    required init(withJSON json: JSON) {
        test <- json["test"]
    }
}

class TestJSON8: TestJSON7 {

    var name: String?
    var lastName: String?

    required init(withJSON json: JSON) {
        super.init(withJSON: json)
        name <- json["name"]
        lastName <- json["lastName"]
    }
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
    func testMapPrimitive() {
        let d1: JSON = ["aBool":true,
                        "a":10,
                        "b":15,
                        "c":25.6,
                        "d":39.4,
                        "e":"Hello world!"]
        let d2: JSON = ["aBool":"1",
                        "a":"10",
                        "b":"15",
                        "c":"25.6",
                        "d":"39.4",
                        "e":"Hello world!"]
        let d3: JSON = ["aBool":NSNumber(value: true),
                        "a":NSNumber(value: 10),
                        "b":NSNumber(value: 15),
                        "c":NSNumber(value: 25.6),
                        "d":NSNumber(value: 39.4),
                        "e":"Hello world!"]
        let d4: JSON = ["aBool":NSDecimalNumber(value: true),
                        "a":NSDecimalNumber(value: 10),
                        "b":NSDecimalNumber(value: 15),
                        "c":NSDecimalNumber(value: 25.6),
                        "d":NSDecimalNumber(value: 39.4),
                        "e":"Hello world!"]
        let d5: JSON = ["aBool":NSDecimalNumber(string: "1"),
                        "a":NSDecimalNumber(string: "10"),
                        "b":NSDecimalNumber(string: "15"),
                        "c":NSDecimalNumber(string: "25.6"),
                        "d":NSDecimalNumber(string: "39.4"),
                        "e":"Hello world!"]

        let array = [d1, d2, d3, d4, d5]
        array.forEach { (d) in
            // Test non optional
            let o1 = TestJSON1(withJSON: d)
            XCTAssertEqual(o1.aBool, true, "Expected '1' but found: '\(o1.aBool)'.")

            XCTAssertEqual(o1.a, 10, "Expected '1' but found: '\(o1.a)'.")
            XCTAssertEqual(o1.b, 10, "Expected '2' but found: '\(o1.b)'.")
            XCTAssertEqual(o1.c, 10, "Expected '3' but found: '\(o1.c)'.")
            XCTAssertEqual(o1.d, 10, "Expected '3' but found: '\(o1.d)'.")
            XCTAssertEqual(o1.e, 10, "Expected '3' but found: '\(o1.e)'.")

            XCTAssertEqual(o1.f, 15, "Expected '1' but found: '\(o1.f)'.")
            XCTAssertEqual(o1.g, 15, "Expected '2' but found: '\(o1.g)'.")
            XCTAssertEqual(o1.h, 15, "Expected '3' but found: '\(o1.h)'.")
            XCTAssertEqual(o1.i, 15, "Expected '3' but found: '\(o1.i)'.")
            XCTAssertEqual(o1.j, 15, "Expected '3' but found: '\(o1.j)'.")

            XCTAssertEqual(o1.k, 25.6, "Expected '25.6' but found: '\(o1.k)'.")
            XCTAssertEqual(o1.l, 39.4, "Expected '39.4' but found: '\(o1.l)'.")
            XCTAssertEqual(o1.m, "Hello world!", "Expected 'Hello world!' but found: '\(o1.m)'.")

            // Test optional
            let o2 = TestJSON2(withJSON: d)
            XCTAssertEqual(o2.aBool, true, "Expected '1' but found: '\(o2.aBool ?? false)'.")

            XCTAssertEqual(o2.a, 10, "Expected '1' but found: '\(o2.a ?? 0)'.")
            XCTAssertEqual(o2.b, 10, "Expected '2' but found: '\(o2.b ?? 0)'.")
            XCTAssertEqual(o2.c, 10, "Expected '3' but found: '\(o2.c ?? 0)'.")
            XCTAssertEqual(o2.d, 10, "Expected '3' but found: '\(o2.d ?? 0)'.")
            XCTAssertEqual(o2.e, 10, "Expected '3' but found: '\(o2.e ?? 0)'.")

            XCTAssertEqual(o2.f, 15, "Expected '1' but found: '\(o2.f ?? 0)'.")
            XCTAssertEqual(o2.g, 15, "Expected '2' but found: '\(o2.g ?? 0)'.")
            XCTAssertEqual(o2.h, 15, "Expected '3' but found: '\(o2.h ?? 0)'.")
            XCTAssertEqual(o2.i, 15, "Expected '3' but found: '\(o2.i ?? 0)'.")
            XCTAssertEqual(o2.j, 15, "Expected '3' but found: '\(o2.j ?? 0)'.")

            XCTAssertEqual(o2.k, 25.6, "Expected '25.6' but found: '\(o2.k ?? 0)'.")
            XCTAssertEqual(o2.l, 39.4, "Expected '39.4' but found: '\(o2.l ?? 0)'.")
            XCTAssertEqual(o2.m, "Hello world!", "Expected 'Hello world!' but found: '\(o2.m ?? "nil")'.")
        }
    }

    func testMapReferenceConvertible() {
        let d: JSON = ["url": "https://www.google.com/?gws_rd=ssl",
                       "date": "2012-04-23T18:25:43.511Z",
                       "data1": "RndpQ29yZQ==",
                       "data2": "2012-04-23T18:25:43.511Z",
                       "url_test":["url": "https://www.google.com/?gws_rd=ssl"]]

        let o = TestJSON3(withJSON: d)
        XCTAssertNotNil(o.url, "Expected not nil but found: '\(o.url?.absoluteString ?? "nil")'.")
        XCTAssertEqual(o.url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(o.url?.absoluteString ?? "nil")'.")

        XCTAssertNotNil(o.date, "Expected not nil but found: '\(String(describing: o.date))'.")

        XCTAssertNotNil(o.data1, "Expected not nil but found: '\(o.data1?.toString() ?? "nil")'.")
        XCTAssertEqual(o.data1?.toString(), "FwiCore", "Expected 'FwiCore' but found: '\(o.data1?.toString() ?? "nil")'.")

        XCTAssertNotNil(o.data2, "Expected not nil but found: '\(o.data2?.toString() ?? "nil")'.")
        XCTAssertEqual(o.data2?.toString(), "2012-04-23T18:25:43.511Z", "Expected '2012-04-23T18:25:43.511Z' but found: '\(o.data2?.toString() ?? "nil")'.")

        XCTAssertNotNil(o.urlTest, "Expected not nil but found: 'nil'.")
        XCTAssertEqual(o.urlTest?.url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(o.urlTest?.url?.absoluteString ?? "nil")'.")
    }

    func testMapArray1() {
        let array = [
            ["url": "https://www.google.com/?gws_rd=ssl"],
            ["url": "https://www.google.com/?gws_rd=ssl"]
        ]

        var list: [URLTest]?
        list <- array

        XCTAssertEqual(list?.count, 2, "Expected '\(array.count)' but found: '\(list?.count ?? 0)'.")
        XCTAssertEqual(list?[0].url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(list?[0].url?.absoluteString ?? "nil")'.")
    }

    func testMapArray2() {
        let d: JSON = [
            "array":[["url": "https://www.google.com/?gws_rd=ssl"], ["url": "https://www.google.com/?gws_rd=ssl"]],
            "arrayInt1":[2, 4, 6],
            "arrayString1":["2", "4", "6"],
            "arrayInt2":["2", "4", "6", "Null"],
            "arrayString2":[2, 4, 6],
            "arrayAny1":["2", "4", "6"],
            "arrayAny2":[2, 4, 6],
            "arrayUrls":["https://www.google.com/?gws_rd=ssl", "https://www.google.com/?gws_rd=ssl"]
        ]

        let o = TestJSON4(withJSON: d)
        XCTAssertNotNil(o.array, "Expected not nil but found: '\(String(describing: o.array))'")
        XCTAssertNotNil(o.arrayInt1, "Expected not nil but found: '\(String(describing: o.arrayInt1))'")
        XCTAssertNotNil(o.arrayString1, "Expected not nil but found: '\(String(describing: o.arrayString1))'")
        XCTAssertNotNil(o.arrayInt2, "Expected not nil but found: '\(String(describing: o.arrayInt2))'.")
        XCTAssertNotNil(o.arrayString2, "Expected not nil but found: '\(String(describing: o.arrayString2))'.")
        XCTAssertNotNil(o.arrayAny1, "Expected not nil but found: '\(String(describing: o.arrayAny1))'.")
        XCTAssertNotNil(o.arrayAny2, "Expected not nil but found: '\(String(describing: o.arrayAny2))'.")
        XCTAssertNotNil(o.arrayUrls, "Expected not nil but found: '\(String(describing: o.arrayUrls))'.")
    }

    func testMapDictionary1() {
        let d: JSON = [
            "urls1":["url": "https://www.google.com/?gws_rd=ssl"],
            "urls2":["url": "https://www.google.com/?gws_rd=ssl"],
            "urls3":["url": "https://www.google.com/?gws_rd=ssl"],
            "urls4":["url": 40],
            "urls5":["url": "40"],
            "urlTest":["url": "https://www.google.com/?gws_rd=ssl"]
        ]

        let o = TestJSON5(withJSON: d)
        XCTAssertNotNil(o.urls1, "Expected not nil but found: '\(String(describing: o.urls1))'.")
        XCTAssertNotNil(o.urls2, "Expected nil but found: '\(String(describing: o.urls2))'.")
        XCTAssertNil(o.urls3, "Expected nil but found: '\(String(describing: o.urls3))'.")
        XCTAssertNotNil(o.urls4, "Expected not nil but found: '\(String(describing: o.urls4))'.")
        XCTAssertNotNil(o.urls5, "Expected not nil but found: '\(String(describing: o.urls5))'.")

        XCTAssertNotNil(o.urlTest, "Expected not nil but found: '\(String(describing: o.urlTest))'.")
        XCTAssertNotNil(o.urlTest?.url, "Expected not nil but found: '\(String(describing: o.urlTest?.url))'.")
        XCTAssertEqual(o.urlTest?.url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(String(describing: o.urlTest?.url?.absoluteString))'.")
    }

    func testMapDictionary2() {
        let d: JSON = [
            "test1": 5,
            "test2": ["url": "https://www.google.com/?gws_rd=ssl"],
            "test3" : ["testDict" : "abc"],
            "test4": [
                ["url": "https://www.google.com/?gws_rd=ssl"],
                ["url": "https://www.google.com/?gws_rd=ssl"],
                ["url": "https://www.google.com/?gws_rd=ssl"]
            ],
            "test5": [2, 4, 6],
            "test6": ["adad", "dadada", "duadgaud"],
            "test7": 1464768697,
            "test8": "2012-10-01T094500GMT"
        ]

        let o = TestJSON6(withJSON: d)
        XCTAssertEqual(o.a, 5, "Expected '5' but found: '\(o.a)'.")
        XCTAssertNotNil(o.z, "Expected not nil but found: '\(String(describing: o.z))'.")
        XCTAssertNotNil(o.z?.url, "Expected not nil but found: '\(String(describing: o.z?.url))'.")
        XCTAssertNotNil(o.d, "Expected not nil but found: '\(String(describing: o.d))'.")
        XCTAssertNotNil(o.arr, "Expected not nil but found: '\(String(describing: o.arr))'.")
        XCTAssertNotNil(o.dateStr, "Expected not nil but found: '\(String(describing: o.dateStr))'.")
    }


//    func testConvertArray1() {
//        let valueJSON: [String : String] = ["1": "1"]
//
//        let array1 = [
//            ["url": "https://www.google.com/?gws_rd=ssl"],
//            ["url": "https://www.google.com/?gws_rd=ssl"]
//        ]
//        
//        let objects = [
//            URLTest("https://www.google.com/?gws_rd=ssl"),
//            URLTest("https://www.google.com/?gws_rd=ssl")
//        ]
//        
//        let array2 = FwiJSONMapper.convert(array: objects)
//        XCTAssertEqual(array2.count, 2, "Expected '\(array1.count)' but found: '\(array2.count)'.")
//        XCTAssertEqual((array2[0])["url"] as! String, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\((array2[0])["url"] ?? "--")'.")
//        
//        let data = try? JSONSerialization.data(withJSONObject: array2, options: JSONSerialization.WritingOptions(rawValue: 0))
//        XCTAssertNotNil(data, "Expected not nil but found nil.")
//    }


//    func testConvertArray2() {
//        let o = TestJSON5()
//        o.array = [
//            URLTest("https://www.google.com/?gws_rd=ssl"),
//            URLTest("https://www.google.com/?gws_rd=ssl")
//        ]
//        o.arrayInt1 = [2, 4, 6]
//        o.arrayString1 = ["2", "4", "6"]
//        o.arrayAny1 = ["2", "4", "6"]
//        o.arrayAny2 = [2, 4, 6]
//        o.arrayUrls = [URL(string: "https://www.google.com/?gws_rd=ssl")!, URL(string: "https://www.google.com/?gws_rd=ssl")!]
//        
//        let d = FwiJSONMapper.convert(model: o)
//        if let array = d["array"] as? [[String : Any]] {
//            XCTAssertEqual(array.count, 2, "Expected '2' but found: '\(array.count)'.")
//            XCTAssertEqual(array[0]["url"] as? String, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(String(describing: array[0]["url"]))'.")
//        } else {
//            XCTFail("Invalid array.")
//        }
//        
//        if let array = d["arrayInt1"] as? [Int] {
//            XCTAssertEqual(array.count, 3, "Expected '3' but found: '\(array.count)'.")
//        } else {
//            XCTFail("Invalid array.")
//        }
//        
//        if let array = d["arrayString1"] as? [String] {
//            XCTAssertEqual(array.count, 3, "Expected '3' but found: '\(array.count)'.")
//        } else {
//            XCTFail("Invalid array.")
//        }
//        
//        if let array = d["arrayAny1"] as? [Any] {
//            XCTAssertEqual(array.count, 3, "Expected '3' but found: '\(array.count)'.")
//            XCTAssertEqual(array[0] as? String, "2", "Expected '2' but found: '\(array[0])'.")
//        } else {
//            XCTFail("Invalid array.")
//        }
//        
//        if let array = d["arrayAny2"] as? [Any] {
//            XCTAssertEqual(array.count, 3, "Expected '3' but found: '\(array.count)'.")
//            XCTAssertEqual(array[0] as? Int, 2, "Expected '2' but found: '\(array[0])'.")
//        } else {
//            XCTFail("Invalid array.")
//        }
//        
//        if let array = d["arrayUrls"] as? [String] {
//            XCTAssertEqual(array.count, 2, "Expected '2' but found: '\(array.count)'.")
//            XCTAssertEqual(array[0], "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(array[0])'.")
//        } else {
//            XCTFail("Invalid array.")
//        }
//    }
////    class TestJSON5: NSObject, FwiJSONModel {
////        
////        var array: [URLTest]?
////        
////        var arrayInt1: [Int]?
////        var arrayString1: [String]?
////        
////        var arrayInt2: [Int]?
////        var arrayString2: [String]?
////        
////        var arrayAny1: [Any]?
////        var arrayAny2: [Any]?
////        
////        var arrayUrls: [URL]?
////    }
//

    func testConvertDictionary1() {
        let d: JSON = [
            "test":["url": "https://www.google.com/?gws_rd=ssl"],
            "name": "a Name",
            "lastName": "a Last name"
        ]
        let o = TestJSON8(withJSON: d)
        let d2 = o.encode()
        
        let d3 = o.encode()
//        XCTAssertEqual(d["a"] as! NSNumber, NSNumber(value: 1), "Expected '1' but found: '\(String(describing: d["a"]))'.")
//        XCTAssertEqual(d["b"] as! NSNumber, NSNumber(value: 2), "Expected '2' but found: '\(String(describing: d["b"]))'.")
//        XCTAssertEqual(d["c"] as! NSNumber, NSNumber(value: 3), "Expected '3' but found: '\(String(describing: d["c"]))'.")
//        XCTAssertEqual(d["e"] as! NSNumber, NSNumber(value: 10), "Expected '10' but found: '\(String(describing: d["e"]))'.")
//        XCTAssertEqual(d["d"] as! String, "Hello world", "Expected 'Hello world' but found: '\(String(describing: d["d"]))'.")
//        XCTAssertEqual(d["g"] as! String, "Hello world", "Expected 'Hello world' but found: '\(String(describing: d["g"]))'.")
//        
//        let data = try? JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
//        XCTAssertNotNil(data, "Expected not nil but found nil.")
    }

//    func testConvertDictionary2() {
//        let o = TestJSON2()
//        o.a = 1
////        o.b = 2
//        o.c = 3
//        o.e = 10
//        o.d = "Hello world"
//        o.f = 10.15
//        
//        let d = FwiJSONMapper.convert(model: o)
//        XCTAssertEqual(d["a"] as! NSNumber, NSNumber(value: 1), "Expected '1' but found: '\(String(describing: d["a"]))'.")
////        XCTAssertEqual(d["b"] as! NSNull, NSNull(), "Expected 'nil' but found: '\(d["b"])'.")
//        XCTAssertEqual(d["c"] as! NSNumber, NSNumber(value: 3), "Expected '3' but found: '\(String(describing: d["c"]))'.")
//        XCTAssertEqual(d["e"] as! NSNumber, NSNumber(value: 10), "Expected '10' but found: '\(String(describing: d["e"]))'.")
//        XCTAssertEqual(d["d"] as! String, "Hello world", "Expected 'Hello world' but found: '\(String(describing: d["d"]))'.")
//        
//        let data = try? JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
//        XCTAssertNotNil(data, "Expected not nil but found nil.")
//    }

    func testConvertDictionary3() {
//        let o = TestJSON3()
//        o.a = 1
//        o.b = 2
//        o.c = 3
//        o.d = "Hello world"
//        o.e = 10
//        o.f = 10.15
//        o.url = URL(string: "https://www.google.com/?gws_rd=ssl")
//        o.data1 = "RndpQ29yZQ==".decodeBase64Data()
//        o.data2 = "2012-04-23T18:25:43.511Z".toData()
//        o.date1 = Date(timeIntervalSince1970: 1464768697)
//        o.date2 = format.date(from: "2012-04-23T18:25:43.511Z")
//        
//        let d = FwiJSONMapper.convert(model: o)
//        XCTAssertEqual(d["a"] as! NSNumber, NSNumber(value: 1), "Expected '1' but found: '\(String(describing: d["a"]))'.")
//        XCTAssertEqual(d["b"] as! NSNumber, NSNumber(value: 2), "Expected 'nil' but found: '\(String(describing: d["b"]))'.")
//        XCTAssertEqual(d["c"] as! NSNumber, NSNumber(value: 3), "Expected '3' but found: '\(String(describing: d["c"]))'.")
//        XCTAssertEqual(d["d"] as! String, "Hello world", "Expected 'Hello world' but found: '\(String(describing: d["d"]))'.")
//        XCTAssertEqual(d["e"] as! NSNumber, NSNumber(value: 10), "Expected '10' but found: '\(String(describing: d["e"]))'.")
//        XCTAssertEqual(d["f"] as! NSNumber, NSNumber(value: Float(10.15)), "Expected '10.15' but found: '\(String(describing: d["f"]))'.")
//        XCTAssertEqual(d["url"] as! String, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(String(describing: d["url"]))'.")
//        XCTAssertEqual(d["data1"] as? String, "RndpQ29yZQ==", "Expected 'RndpQ29yZQ==' but found: '\(String(describing: d["data1"]))'.")
//        XCTAssertEqual(d["data2"] as? String, "2012-04-23T18:25:43.511Z".encodeBase64String(), "Expected '\(String(describing: "2012-04-23T18:25:43.511Z".encodeBase64String()))' but found: '\(String(describing: d["data2"]))'.")
//        XCTAssertEqual(d["date1"] as! String, format.string(from: Date(timeIntervalSince1970: 1464768697)), "Expected '\(format.string(from: Date(timeIntervalSince1970: 1464768697)))' but found: '\(String(describing: d["date1"]))'.")
//        XCTAssertEqual(d["date2"] as! String, "2012-04-23T18:25:43.511Z", "Expected '2012-04-23T18:25:43.511Z' but found: '\(String(describing: d["date2"]))'.")
//        
//        let data = try? JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
//        XCTAssertNotNil(data, "Expected not nil but found nil.")
    }

    // MARK: Additional cases
    func testAdditionalCase01() {
        let dictionary: JSON = [
            "test": "Hello World"
        ]

//        let (model, err) = FwiJSONMapper.map(dictionary: dictionary, toModel: TestJSON8.self)
//        XCTAssertNotNil(err, "Expected not nil but found: '\(String(describing: err))'.")
//        XCTAssertNotNil(model, "Expected not nil but found: '\(String(describing: model))'.")
    }

    func testAdditionalCase02() {
        let d: JSON = [
            "name":"Hello world",
            "last_name":"last_name"
        ]

//        var o = TestJSON9()
//        let _ = FwiJSONMapper.map(dictionary: d, toObject: &o)
//
//        XCTAssertEqual(o.name, "Hello world", "Expected \"Hello world\" but found: '\(String(describing: o.name))'.")
    }
}
