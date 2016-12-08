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


@objc(URLTest)
class URLTest: NSObject {
    var url: URL?
    
    override init() {
    }
    convenience init(_ urlString: String) {
        self.init()
        url = URL(string: urlString)
    }
}

class TestJSON1: NSObject {

    var a: Int = 0
    var b: Float = 0
    var c: Double = 0
    var d: String = ""
    var g: String?

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

class TestJSON4 {

    var urls1: [String:String]?
    var urls2: [String:URL]?
    var urls3: [String:Int]?
    var urls4: [String:Int]?
    var urlTest: URLTest?
}

class TestJSON5: NSObject, FwiJSONModel {
    
    var array: [URLTest]?
    
    var arrayInt1: [Int]?
    var arrayString1: [String]?
    
    var arrayInt2: [Int]?
    var arrayString2: [String]?
    
    var arrayAny1: [Any]?
    var arrayAny2: [Any]?
    
    var arrayUrls: [URL]?
}

class TestJSON6: NSObject, FwiJSONModel {
    
    var a: Int = 0
    var z: URLTest?
    var d: [String: Any]?
    var arr: [URLTest]?
    var arrNormal: [Int]?
    var arrString: [String]?
    var date: Date?
    var dateStr: Date?
    
    var keyMapper: [String : String]? {
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

class TestJSON7: NSObject, FwiJSONModel {
    var test: URLTest?
}

class TestJSON8: NSObject, FwiJSONModel {

    var name: String?
    var lastName: String?

    var keyMapper: [String : String]? {
        return ["name":"name", "last_name":"lastName"]
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
    func testConvertArray1() {
        let array1 = [
            ["url": "https://www.google.com/?gws_rd=ssl"],
            ["url": "https://www.google.com/?gws_rd=ssl"]
        ]
        
        let objects = [
            URLTest("https://www.google.com/?gws_rd=ssl"),
            URLTest("https://www.google.com/?gws_rd=ssl")
        ]
        
        let array2 = FwiJSONMapper.convert(array: objects)
        XCTAssertEqual(array2.count, 2, "Expected '\(array1.count)' but found: '\(array2.count)'.")
        XCTAssertEqual((array2[0])["url"] as? String, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\((array2[0])["url"])'.")
        
        let data = try? JSONSerialization.data(withJSONObject: array2, options: JSONSerialization.WritingOptions(rawValue: 0))
        XCTAssertNotNil(data, "Expected not nil but found nil.")
    }
    func testMapArray1() {
        let array = [
            ["url": "https://www.google.com/?gws_rd=ssl"],
            ["url": "https://www.google.com/?gws_rd=ssl"]
        ]
        
        let (objects, err) = FwiJSONMapper.map(array: array, toModel: URLTest.self)
        XCTAssertNil(err, "Expected nil but found: '\(err)'.")
        XCTAssertEqual(objects?.count, 2, "Expected '\(array.count)' but found: '\(objects?.count)'.")
        XCTAssertEqual(objects?[0].url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(objects?[0].url?.absoluteString)'.")
    }
    
    func testConvertArray2() {
        let o = TestJSON5()
        o.array = [
            URLTest("https://www.google.com/?gws_rd=ssl"),
            URLTest("https://www.google.com/?gws_rd=ssl")
        ]
        o.arrayInt1 = [2, 4, 6]
        o.arrayString1 = ["2", "4", "6"]
        o.arrayAny1 = ["2", "4", "6"]
        o.arrayAny2 = [2, 4, 6]
        o.arrayUrls = [URL(string: "https://www.google.com/?gws_rd=ssl")!, URL(string: "https://www.google.com/?gws_rd=ssl")!]
        
        let d = FwiJSONMapper.convert(model: o)
        if let array = d["array"] as? [[String : Any]] {
            XCTAssertEqual(array.count, 2, "Expected '2' but found: '\(array.count)'.")
            XCTAssertEqual(array[0]["url"] as? String, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(array[0]["url"])'.")
        } else {
            XCTFail("Invalid array.")
        }
        
        if let array = d["arrayInt1"] as? [Int] {
            XCTAssertEqual(array.count, 3, "Expected '3' but found: '\(array.count)'.")
        } else {
            XCTFail("Invalid array.")
        }
        
        if let array = d["arrayString1"] as? [String] {
            XCTAssertEqual(array.count, 3, "Expected '3' but found: '\(array.count)'.")
        } else {
            XCTFail("Invalid array.")
        }
        
        if let array = d["arrayAny1"] as? [Any] {
            XCTAssertEqual(array.count, 3, "Expected '3' but found: '\(array.count)'.")
            XCTAssertEqual(array[0] as? String, "2", "Expected '2' but found: '\(array[0])'.")
        } else {
            XCTFail("Invalid array.")
        }
        
        if let array = d["arrayAny2"] as? [Any] {
            XCTAssertEqual(array.count, 3, "Expected '3' but found: '\(array.count)'.")
            XCTAssertEqual(array[0] as? Int, 2, "Expected '2' but found: '\(array[0])'.")
        } else {
            XCTFail("Invalid array.")
        }
        
        if let array = d["arrayUrls"] as? [String] {
            XCTAssertEqual(array.count, 2, "Expected '2' but found: '\(array.count)'.")
            XCTAssertEqual(array[0], "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(array[0])'.")
        } else {
            XCTFail("Invalid array.")
        }
    }
//    class TestJSON5: NSObject, FwiJSONModel {
//        
//        var array: [URLTest]?
//        
//        var arrayInt1: [Int]?
//        var arrayString1: [String]?
//        
//        var arrayInt2: [Int]?
//        var arrayString2: [String]?
//        
//        var arrayAny1: [Any]?
//        var arrayAny2: [Any]?
//        
//        var arrayUrls: [URL]?
//    }
    
    func testMapArray2() {
        let d: [String : Any] = [
            "array":[["url": "https://www.google.com/?gws_rd=ssl"], ["url": "https://www.google.com/?gws_rd=ssl"]],
            "arrayInt1":[2, 4, 6],
            "arrayString1":["2", "4", "6"],
            "arrayInt2":["2", "4", "6", "Null"],
            "arrayString2":[2, 4, 6],
            "arrayAny1":["2", "4", "6"],
            "arrayAny2":[2, 4, 6],
            "arrayUrls":["https://www.google.com/?gws_rd=ssl", "https://www.google.com/?gws_rd=ssl"]
        ]
        
        var o = TestJSON5()
        let err = FwiJSONMapper.map(dictionary: d, toObject: &o)
        
        XCTAssertNotNil(err, "Expected not nil but found: '\(err)'.")
        
        XCTAssertNil(o.array, "Expected nil but found: '\(o.array)'")
        XCTAssertNil(o.arrayInt1, "Expected nil but found: '\(o.arrayInt1)'")
        XCTAssertNil(o.arrayString1, "Expected nil but found: '\(o.arrayString1)'")
        XCTAssertNil(o.arrayInt2, "Expected nil but found: '\(o.arrayInt2)'.")
        XCTAssertNil(o.arrayString2, "Expected nil but found: '\(o.arrayString2)'.")
        XCTAssertNil(o.arrayAny1, "Expected nil but found: '\(o.arrayAny1)'.")
        XCTAssertNil(o.arrayAny2, "Expected nil but found: '\(o.arrayAny2)'.")
        XCTAssertNil(o.arrayUrls, "Expected nil but found: '\(o.arrayUrls)'.")
    }
    
    func testConvertDictionary1() {
        let o = TestJSON1()
        o.a = 1
        o.b = 2
        o.c = 3
        o.e = 10
        o.d = "Hello world"
        o.g = "Hello world"
        
        let d = FwiJSONMapper.convert(model: o)
        XCTAssertEqual(d["a"] as! NSNumber, NSNumber(value: 1), "Expected '1' but found: '\(d["a"])'.")
        XCTAssertEqual(d["b"] as! NSNumber, NSNumber(value: 2), "Expected '2' but found: '\(d["b"])'.")
        XCTAssertEqual(d["c"] as! NSNumber, NSNumber(value: 3), "Expected '3' but found: '\(d["c"])'.")
        XCTAssertEqual(d["e"] as! NSNumber, NSNumber(value: 10), "Expected '10' but found: '\(d["e"])'.")
        XCTAssertEqual(d["d"] as! String, "Hello world", "Expected 'Hello world' but found: '\(d["d"])'.")
        XCTAssertEqual(d["g"] as! String, "Hello world", "Expected 'Hello world' but found: '\(d["g"])'.")
        
        let data = try? JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
        XCTAssertNotNil(data, "Expected not nil but found nil.")
    }
    func testMapDictionary1() {
        let d: [String : Any] = ["a":NSNumber(value: 1), "b":NSNumber(value: 2), "c":NSNumber(value: 3), "d":"Hello world", "e":"10", "f":"10.15", "g":"Hello world"]
        
        var o = TestJSON1()
        let _ = FwiJSONMapper.map(dictionary: d, toObject: &o)
        
        XCTAssertEqual(o.a, 1, "Expected '1' but found: '\(o.a)'.")
        XCTAssertEqual(o.b, 2, "Expected '2' but found: '\(o.b)'.")
        XCTAssertEqual(o.c, 3, "Expected '3' but found: '\(o.c)'.")
        XCTAssertEqual(o.e, 10, "Expected '10' but found: '\(o.e)'.")
        XCTAssertEqual(o.d, "Hello world", "Expected 'Hello world' but found: '\(o.d)'.")
        XCTAssertEqual(o.g, "Hello world", "Expected 'Hello world' but found: '\(o.g)'.")
    }
    
    func testConvertDictionary2() {
        let o = TestJSON2()
        o.a = 1
//        o.b = 2
        o.c = 3
        o.e = 10
        o.d = "Hello world"
        o.f = 10.15
        
        let d = FwiJSONMapper.convert(model: o)
        XCTAssertEqual(d["a"] as! NSNumber, NSNumber(value: 1), "Expected '1' but found: '\(d["a"])'.")
//        XCTAssertEqual(d["b"] as! NSNull, NSNull(), "Expected 'nil' but found: '\(d["b"])'.")
        XCTAssertEqual(d["c"] as! NSNumber, NSNumber(value: 3), "Expected '3' but found: '\(d["c"])'.")
        XCTAssertEqual(d["e"] as! NSNumber, NSNumber(value: 10), "Expected '10' but found: '\(d["e"])'.")
        XCTAssertEqual(d["d"] as! String, "Hello world", "Expected 'Hello world' but found: '\(d["d"])'.")
        
        let data = try? JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
        XCTAssertNotNil(data, "Expected not nil but found nil.")
    }
    func testMapDictionary2() {
//        let d: [String : Any] = ["a":NSNumber(value: 1), "b":NSNumber(value: 2), "c":NSNumber(value: 3), "d":"Hello world", "e":"10", "f":"10.15"]
//        
//        var o = TestJSON2()
//        let _ = FwiJSONMapper.map(dictionary: d, toObject: &o)
//        
//        XCTAssertEqual(o.a, 1, "Expected '1' but found: '\(o.a)'.")
//        XCTAssertEqual(o.b, 2, "Expected '2' but found: '\(o.b)'.")
//        XCTAssertEqual(o.c, 3, "Expected '3' but found: '\(o.c)'.")
//        XCTAssertEqual(o.e, 10, "Expected '10' but found: '\(o.e)'.")
//        XCTAssertEqual(o.d, "Hello world", "Expected 'Hello world' but found: '\(o.d)'.")
//        XCTAssertNil(o.g, "Expected nil but found: '\(o.g)'.")
    }

    func testConvertDictionary3() {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let o = TestJSON3()
        o.a = 1
        o.b = 2
        o.c = 3
        o.d = "Hello world"
        o.e = 10
        o.f = 10.15
        o.url = URL(string: "https://www.google.com/?gws_rd=ssl")
        o.data1 = "RndpQ29yZQ==".decodeBase64Data()
        o.data2 = "2012-04-23T18:25:43.511Z".toData()
        o.date1 = Date(timeIntervalSince1970: 1464768697)
        o.date2 = format.date(from: "2012-04-23T18:25:43.511Z")
        
        let d = FwiJSONMapper.convert(model: o)
        XCTAssertEqual(d["a"] as! NSNumber, NSNumber(value: 1), "Expected '1' but found: '\(d["a"])'.")
        XCTAssertEqual(d["b"] as! NSNumber, NSNumber(value: 2), "Expected 'nil' but found: '\(d["b"])'.")
        XCTAssertEqual(d["c"] as! NSNumber, NSNumber(value: 3), "Expected '3' but found: '\(d["c"])'.")
        XCTAssertEqual(d["d"] as! String, "Hello world", "Expected 'Hello world' but found: '\(d["d"])'.")
        XCTAssertEqual(d["e"] as! NSNumber, NSNumber(value: 10), "Expected '10' but found: '\(d["e"])'.")
        XCTAssertEqual(d["f"] as! NSNumber, NSNumber(value: Float(10.15)), "Expected '10.15' but found: '\(d["f"])'.")
        XCTAssertEqual(d["url"] as! String, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(d["url"])'.")
        XCTAssertEqual(d["data1"] as? String, "RndpQ29yZQ==", "Expected 'RndpQ29yZQ==' but found: '\(d["data1"])'.")
        XCTAssertEqual(d["data2"] as? String, "2012-04-23T18:25:43.511Z".encodeBase64String(), "Expected '\("2012-04-23T18:25:43.511Z".encodeBase64String())' but found: '\(d["data2"])'.")
        XCTAssertEqual(d["date1"] as! String, format.string(from: Date(timeIntervalSince1970: 1464768697)), "Expected '\(format.string(from: Date(timeIntervalSince1970: 1464768697)))' but found: '\(d["date1"])'.")
        XCTAssertEqual(d["date2"] as! String, "2012-04-23T18:25:43.511Z", "Expected '2012-04-23T18:25:43.511Z' but found: '\(d["date2"])'.")
        
        let data = try? JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
        XCTAssertNotNil(data, "Expected not nil but found nil.")
    }
    func testMapDictionary3() {
        let d: [String : Any] = ["a":1,
                                 "b":2,
                                 "c":3,
                                 "d":"Hello world",
                                 "e":"10",
                                 "f":"10.15",
                                 "g":"Hello world",
                                 "url": "https://www.google.com/?gws_rd=ssl",
                                 "data1": "RndpQ29yZQ==",
                                 "data2": "2012-04-23T18:25:43.511Z",
                                 "date1": 1464768697,
                                 "date2": "2012-04-23T18:25:43.511Z"]
        var o = TestJSON3()
        let _ = FwiJSONMapper.map(dictionary: d, toObject: &o)
        
        XCTAssertEqual(o.a, 1, "Expected '1' but found: '\(o.a)'.")
        XCTAssertEqual(o.b, 2, "Expected '2' but found: '\(o.b)'.")
        XCTAssertEqual(o.c, 3, "Expected '3' but found: '\(o.c)'.")
        XCTAssertEqual(o.e, 10, "Expected '10' but found: '\(o.e)'.")

        XCTAssertEqual(o.d, "Hello world", "Expected 'Hello world' but found: '\(o.d)'.")
        XCTAssertNotNil(o.url, "Expected not nil but found: '\(o.url)'.")
        XCTAssertEqual(o.url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(o.url?.absoluteString)'.")
        XCTAssertNotNil(o.data1, "Expected not nil but found: '\(o.data1)'.")
        XCTAssertEqual(o.data1?.toString(), "FwiCore", "Expected 'FwiCore' but found: '\(o.data1?.toString())'.")
        XCTAssertNotNil(o.data2, "Expected not nil but found: '\(o.data2)'.")
        XCTAssertEqual(o.data2?.toString(), "2012-04-23T18:25:43.511Z", "Expected '2012-04-23T18:25:43.511Z' but found: '\(o.data2?.toString())'.")
        XCTAssertNotNil(o.date1, "Expected not nil but found: '\(o.date1)'.")
        XCTAssertNotNil(o.date2, "Expected not nil but found: '\(o.date2)'.")

        let (o1, _) = TestJSON3.map(dictionary: d)
        XCTAssertEqual(o1?.a, 1, "Expected '1' but found: '\(o.a)'.")
        XCTAssertEqual(o1?.b, 2, "Expected '2' but found: '\(o.b)'.")
        XCTAssertEqual(o1?.c, 3, "Expected '3' but found: '\(o.c)'.")
        XCTAssertEqual(o1?.e, 10, "Expected '10' but found: '\(o.e)'.")

        XCTAssertEqual(o1?.d, "Hello world", "Expected 'Hello world' but found: '\(o.d)'.")
        XCTAssertNotNil(o1?.url, "Expected not nil but found: '\(o.url)'.")
        XCTAssertEqual(o1?.url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(o.url?.absoluteString)'.")
        XCTAssertNotNil(o1?.data1, "Expected not nil but found: '\(o.data1)'.")
        XCTAssertEqual(o1?.data1?.toString(), "FwiCore", "Expected 'FwiCore' but found: '\(o.data1?.toString())'.")
        XCTAssertNotNil(o1?.data2, "Expected not nil but found: '\(o.data2)'.")
        XCTAssertEqual(o1?.data2?.toString(), "2012-04-23T18:25:43.511Z", "Expected '2012-04-23T18:25:43.511Z' but found: '\(o.data2?.toString())'.")
        XCTAssertNotNil(o1?.date1, "Expected not nil but found: '\(o.date1)'.")
        XCTAssertNotNil(o1?.date2, "Expected not nil but found: '\(o.date2)'.")
    }
    
    func testMapDictionary4() {
//        let d: [String : Any] = ["a":1,
//                                 "b":2,
//                                 "c":3,
//                                 "d":"Hello world",
//                                 "e":"10",
//                                 "f":"10.15",
//                                 "urls1":["url": "https://www.google.com/?gws_rd=ssl"],
//                                 "urls2":["url": "https://www.google.com/?gws_rd=ssl"],
//                                 "urls3":["url": "https://www.google.com/?gws_rd=ssl"],
//                                 "urls4":["url": 40],
//                                 "urlTest":["url": "https://www.google.com/?gws_rd=ssl"]]
//        var o = TestJSON4()
//        let _ = FwiJSONMapper.map(dictionary: d, toObject: &o)
//        
//        XCTAssertNotNil(o.urls1, "Expected not nil but found: '\(o.urls1)'.")
//        XCTAssertNotNil(o.urls2, "Expected nil but found: '\(o.urls2)'.")
//        XCTAssertNil(o.urls3, "Expected nil but found: '\(o.urls3)'.")
//        XCTAssertNotNil(o.urls4, "Expected not nil but found: '\(o.urls4)'.")
//        
//        XCTAssertNotNil(o.urlTest, "Expected not nil but found: '\(o.urlTest)'.")
//        XCTAssertNotNil(o.urlTest?.url, "Expected not nil but found: '\(o.urlTest?.url)'.")
//        XCTAssertEqual(o.urlTest?.url?.absoluteString, "https://www.google.com/?gws_rd=ssl", "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(o.urlTest?.url?.absoluteString)'.")
    }
    
    func testModelJSON() {
        let dictionary = ["test1": 5,
                          "test2": ["url": "https://www.google.com/?gws_rd=ssl"],
                          "test3" : ["testDict" : "abc"],
                          "test5": [
                            ["url": "https://www.google.com/?gws_rd=ssl"],
                            ["url": "https://www.google.com/?gws_rd=ssl"],
                            ["url": "https://www.google.com/?gws_rd=ssl"]
                          ],
                          "test6": [2, 4, 6],
                          "test7": ["adad", "dadada", "duadgaud"],
                          "test8": 1464768697,
                          "test9": "2012-10-01T094500GMT"
            ] as [String : Any]
        
        var o = TestJSON6()
        FwiJSONMapper.map(dictionary: dictionary, toObject: &o)
        
        let d = FwiJSONMapper.convert(model: o)
        XCTAssertEqual(d["test1"] as! NSNumber, dictionary["test1"] as! NSNumber, "Expected '5' but found: '\(d["test1"])'.")
        
        if let o1 = d["test2"] as? [String : String], let o2 = dictionary["test2"] as? [String : String] {
            XCTAssertEqual(o1["url"], o2["url"], "Expected 'https://www.google.com/?gws_rd=ssl' but found: '\(o1["url"])'.")
        } else {
            XCTFail("Invalid dictionary.")
        }
        
        if let d1 = d["test3"] as? [String : String], let d2 = dictionary["test3"] as? [String : String] {
            XCTAssertEqual(d1, d2, "Expected '\(d2)' but found: '\(d1)'.")
        } else {
            XCTFail("Invalid dictionary.")
        }
        
        if let a1 = d["test5"] as? [[String : String]], let a2 = dictionary["test5"] as? [[String : String]] {
            XCTAssertEqual(a1[0], a2[0], "Expected '\(a2[0])' but found: '\(a1[0])'.")
        } else {
            XCTFail("Invalid array.")
        }
        
        if let a1 = d["test6"] as? [Int], let a2 = dictionary["test6"] as? [Int] {
            XCTAssertEqual(a1, a2, "Expected '\(a2)' but found: '\(a1)'.")
        } else {
            XCTFail("Invalid array.")
        }
        
        if let a1 = d["test7"] as? [String], let a2 = dictionary["test7"] as? [String] {
            XCTAssertEqual(a1, a2, "Expected '\(a2)' but found: '\(a1)'.")
        } else {
            XCTFail("Invalid array.")
        }
        
        let data = try? JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
        XCTAssertNotNil(data, "Expected not nil but found nil.")
    }
    func testJSONModel() {
        let dictionary = ["test1": 5,
                          "test2": ["url": "https://www.google.com/?gws_rd=ssl"],
                          "test3" : ["testDict" : "abc"],
                          "test5": [
                            ["url": "https://www.google.com/?gws_rd=ssl"],
                            ["url": "https://www.google.com/?gws_rd=ssl"],
                            ["url": "https://www.google.com/?gws_rd=ssl"]
                          ],
                          "test6": [2, 4, 6],
                          "test7": ["adad", "dadada", "duadgaud"],
                          "test8": 1464768697,
                          "test9": "2012-10-01T094500GMT"
                         ] as [String : Any]
        
        var o = TestJSON6()
        FwiJSONMapper.map(dictionary: dictionary, toObject: &o)
        
        XCTAssertEqual(o.a, 5, "Expected '1' but found: '\(o.a)'.")
        XCTAssertNotNil(o.z, "Expected not nil but found: '\(o.z)'.")
        XCTAssertNotNil(o.z?.url, "Expected not nil but found: '\(o.z?.url)'.")
        XCTAssertNotNil(o.d, "Expected not nil but found: '\(o.d)'.")
        XCTAssertNotNil(o.arr, "Expected not nil but found: '\(o.arr)'.")
        XCTAssertNotNil(o.dateStr, "Expected not nil but found: '\(o.dateStr)'.")
    }

    func testAdditionalCase01() {
        let dictionary = [
            "test": "Hello World"
        ] as [String : Any]

        let (model, err) = FwiJSONMapper.map(dictionary: dictionary, toModel: TestJSON7.self)
        XCTAssertNotNil(err, "Expected not nil but found: '\(err)'.")
        XCTAssertNotNil(model, "Expected not nil but found: '\(model)'.")
    }

    func testAdditionalCase02() {
        let d: [String : Any] = ["name":"Hello world", "last_name":"last_name"]
        var o = TestJSON8()
        let _ = FwiJSONMapper.map(dictionary: d, toObject: &o)

        XCTAssertEqual(o.name, "Hello world", "Expected \"Hello world\" but found: '\(o.name)'.")
    }

    func testPerformance() {
        let dictionary = ["test1": 5,
                          "test2": ["url": "https://www.google.com/?gws_rd=ssl"],
                          "test3" : ["testDict" : "abc"],
                          "test5": [
                            ["url": "https://www.google.com/?gws_rd=ssl"],
                            ["url": "https://www.google.com/?gws_rd=ssl"],
                            ["url": "https://www.google.com/?gws_rd=ssl"]
                          ],
                          "test6": [2, 4, 6],
                          "test7": ["adad", "dadada", "duadgaud"],
                          "test8": 1464768697,
                          "test9": "2012-10-01T094500GMT"
                         ] as [String : Any]
        
        measure {
            let (_, _) = FwiJSONMapper.map(dictionary: dictionary, toModel: TestJSON6.self)
        }
    }
}
