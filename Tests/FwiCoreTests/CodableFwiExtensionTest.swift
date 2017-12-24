//  Project name: FwiCore
//  File name   : CodableFwiExtensionTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/21/17
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


fileprivate struct TestBool: Codable {
    var a: Bool?
    var b: Bool?
    var c: Bool?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        container.parse(&a, key: .a)
        container.parse(&b, key: .b)
        container.parse(&c, key: .c)
    }
}

fileprivate struct TestFloatDouble: Codable {
    var a: Float?
    var b: Float?
    var c: Double?
    var d: Double?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        container.parse(&a, key: .a)
        container.parse(&b, key: .b)
        container.parse(&c, key: .c)
        container.parse(&d, key: .d)
    }
}

fileprivate struct TestNumericNumber: Codable {
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        container.parse(&a, key: .a)
        container.parse(&b, key: .b)
        container.parse(&c, key: .c)
        container.parse(&d, key: .d)
        container.parse(&e, key: .e)

        container.parse(&f, key: .f)
        container.parse(&g, key: .g)
        container.parse(&h, key: .h)
        container.parse(&i, key: .i)
        container.parse(&j, key: .j)
    }
}

fileprivate struct TestData: Codable {
    var a: Data?
    var b: Data?
    var c: Data?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        container.parse(&a, key: .a)
        container.parse(&b, key: .b)
        container.parse(&c, key: .c)
    }
}

fileprivate struct TestDate: Codable {
    var a: Date?
    var b: Date?
    var c: Date?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        container.parse(&a, key: .a)
        container.parse(&b, key: .b)
        container.parse(&c, key: .c)
    }
}

fileprivate struct TestURL: Codable {
    var a: URL?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        container.parse(&a, key: .a)
    }
}

fileprivate enum TestEnum: String, Codable {
    case firstName = "first_name"
    case lastName = "last_name"
}

fileprivate struct TestModel1: Codable {

    var name: String?
    var last: String?
    var data: Data?
}

fileprivate struct TestModel2: Codable {

    var age: UInt?
    var name: String?
    var last: String?

    var enumValue: TestEnum?
    var object: [String:String]?

    var model: TestModel1?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        container.parse(&age, key: .age)
        container.parse(&name, key: .name)
        container.parse(&last, key: .last)

        container.parse(&object, key: .object)
        container.parse(&enumValue, key: .enumValue)

        container.parse(&model, key: .model)
    }
}


class CodableFwiExtensionTest: XCTestCase {


    fileprivate let json = """
        {"name":"FwiCore","last":"FwiCore","data":"RndpQ29yZQ=="}
    """.trim()

    fileprivate let json2 = """
        {"name":"FwiCore","last":"FwiCore","age":"10","enumValue":"last_name","object":{"name":"Phuc","last":"Tran"}, "model":{"name":"FwiCore","last":"FwiCore","data":"RndpQ29yZQ=="}}
    """.trim()


    // MARK: Test Cases
    func testEncodeJSON() {
        var model = TestModel1()
        model.name = "FwiCore"
        model.last = "FwiCore"
        model.data = "FwiCore".toData()

        let data = model.encodeJSON()
        XCTAssertNotNil(data, "Expected not nil but found: \(String(describing: data)).")
        XCTAssertEqual(data?.toString(), json, "Expected '\(json)' but found: \(String(describing: data?.toString())).")
    }

    func testDecodeJSON() {
        let model = TestModel1.decodeJSON(json.toData())

        XCTAssertNotNil(model, "Expected not nil but found: \(String(describing: model)).")
        XCTAssertEqual(model?.name, "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model?.name)).")
        XCTAssertEqual(model?.data, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model?.data)).")
    }

    func testBool() {
        let json = """
            {"a":0,"b":true,"c":"TRUE"}
        """.trim()

        let model = TestBool.decodeJSON(json.toData())
        XCTAssertTrue(model?.a == false, "Expected 'false' but found: \(String(describing: model?.a)).")
        XCTAssertTrue(model?.b == true, "Expected 'true' but found: \(String(describing: model?.b)).")
        XCTAssertTrue(model?.c == true, "Expected 'true' but found: \(String(describing: model?.c)).")
    }

    func testFloatDouble() {
        let json = """
            {"a":10.5,"b":"15.4","c":10.5,"d":"15.4"}
        """.trim()

        let model = TestFloatDouble.decodeJSON(json.toData())
        XCTAssertTrue(model?.a == 10.5, "Expected '10.5' but found: \(String(describing: model?.a)).")
        XCTAssertTrue(model?.b == 15.4, "Expected '15.4' but found: \(String(describing: model?.b)).")
        XCTAssertTrue(model?.c == 10.5, "Expected '10.5' but found: \(String(describing: model?.c)).")
        XCTAssertTrue(model?.d == 15.4, "Expected '15.4' but found: \(String(describing: model?.d)).")
    }

    func testNumericNumber() {
        let json = """
            {"a":-2,"b":"-1","c":0,"d":"1","e":"2", "f":127,"g":"128","h":129,"i":"400","j":"500"}
        """.trim()

        let model = TestNumericNumber.decodeJSON(json.toData())
        XCTAssertTrue(model?.a == -2, "Expected '-2' but found: \(String(describing: model?.a)).")
        XCTAssertTrue(model?.b == -1, "Expected '-1' but found: \(String(describing: model?.b)).")
        XCTAssertTrue(model?.c ==  0, "Expected '0' but found: \(String(describing: model?.c)).")
        XCTAssertTrue(model?.d ==  1, "Expected '1' but found: \(String(describing: model?.d)).")
        XCTAssertTrue(model?.e ==  2, "Expected '2' but found: \(String(describing: model?.e)).")

        XCTAssertTrue(model?.f == 127, "Expected '127' but found: \(String(describing: model?.f)).")
        XCTAssertTrue(model?.g == 128, "Expected '128' but found: \(String(describing: model?.g)).")
        XCTAssertTrue(model?.h == 129, "Expected '129' but found: \(String(describing: model?.h)).")
        XCTAssertTrue(model?.i == 400, "Expected '400' but found: \(String(describing: model?.i)).")
        XCTAssertTrue(model?.j == 500, "Expected '500' but found: \(String(describing: model?.j)).")
    }

    func testData() {
        let json = """
            {"a":"RndpQ29yZQ==","b":"FwiCore","c":"467769436f7265"}
        """.trim()

        let model = TestData.decodeJSON(json.toData())
        XCTAssertEqual(model?.a, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model?.a)).")
        XCTAssertEqual(model?.b, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model?.b)).")
        XCTAssertEqual(model?.c, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model?.c)).")
    }

    func testDate() {
        let date = Date()
        let time = round(date.timeIntervalSince1970)
        
        let json = """
            {"a":\(time), "b":"\(time)", "c":"2017-12-23T16:54:30Z"}
        """.trim()

        let model = TestDate.decodeJSON(json.toData())
        XCTAssertEqual(model?.a?.timeIntervalSince1970, time, "Expected '\(time)' but found: \(String(describing: model?.a)).")
        XCTAssertEqual(model?.b?.timeIntervalSince1970, time, "Expected '\(time)' but found: \(String(describing: model?.b)).")
        XCTAssertEqual(model?.c?.timeIntervalSince1970, 1514048070.0, "Expected '\(1514048070)' but found: \(String(describing: model?.c)).")
    }

    func testURL() {
        let json = """
            {"a":"https://www.google.com"}
        """.trim()

        let model = TestURL.decodeJSON(json.toData())
        XCTAssertEqual(model?.a?.absoluteString, "https://www.google.com", "Expected '\("https://www.google.com")' but found: \(String(describing: model?.a)).")
    }

    func testCodable() {
        let model = TestModel2.decodeJSON(json2.toData())
        XCTAssertEqual(model?.age, 10, "Expected '10' but found: \(String(describing: model?.age)).")
        XCTAssertEqual(model?.name, "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model?.name)).")
        XCTAssertEqual(model?.last, "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model?.last)).")

        XCTAssertEqual(model?.enumValue, TestEnum.lastName, "Expected '\(TestEnum.lastName)' but found: \(String(describing: model?.enumValue)).")
        XCTAssertEqual(model?.object ?? [:], ["name":"Phuc","last":"Tran"], "Expected '\(["name":"Phuc","last":"Tran"])' but found: \(String(describing: model?.object)).")

        XCTAssertNotNil(model?.model, "Expected not nil but found: \(String(describing: model)).")
        XCTAssertEqual(model?.model?.name, "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model?.name)).")
        XCTAssertEqual(model?.model?.data, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model?.model?.data)).")
    }
}
