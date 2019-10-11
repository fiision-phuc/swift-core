//  Project name: FwiCore
//  File name   : KeyedDecodingContainer+FwiExtensionTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/21/17
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

final class KeyedDecodingContainerFwiExtensionTest: XCTestCase {

    // MARK: Setup
    override func setUp() {
        super.setUp()
        FwiCore.debug = true
        Log.consoleLog()
    }

    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test Cases
    func testBool() {
        let json = """
            {"a":0,"b":true,"c":"TRUE"}
        """

        do {
            let model = try BoolModel.decodeJSON(json.trim().toData())
            XCTAssertTrue(model.a == false, "Expected 'false' but found: \(String(describing: model.a)).")
            XCTAssertTrue(model.b == true, "Expected 'true' but found: \(String(describing: model.b)).")
            XCTAssertTrue(model.c == true, "Expected 'true' but found: \(String(describing: model.c)).")
            XCTAssertNil(model.oA)
            XCTAssertNil(model.oB)
            XCTAssertNil(model.oC)
        } catch {
            XCTFail(error.localizedDescription)
        }

//        let performanceJson = """
//            {"a":false,"b":true,"c":true}
//        """
//        guard let data = performanceJson.trim().toData() else {
//            return
//        }
//
//        FwiMeasure.time {
//            do {
//                _ = try BoolModel.decodeJSON(data)
//            } catch {
//                XCTFail(error.localizedDescription)
//            }
//        }
//        FwiMeasure.time {
//            do {
//                _ = try BoolModelPerformance.decodeJSON(data)
//            } catch {
//                XCTFail(error.localizedDescription)
//            }
//        }
    }

    func testFloatDouble() {
        let json = """
            {"a":10.5,"b":"15.4","c":10.5,"d":"15.4"}
        """

        do {
            let model = try TestFloatDouble.decodeJSON(json.trim().toData())
            XCTAssertTrue(model.a == 10.5, "Expected '10.5' but found: \(String(describing: model.a)).")
            XCTAssertTrue(model.b == 15.4, "Expected '15.4' but found: \(String(describing: model.b)).")
            XCTAssertTrue(model.c == 10.5, "Expected '10.5' but found: \(String(describing: model.c)).")
            XCTAssertTrue(model.d == 15.4, "Expected '15.4' but found: \(String(describing: model.d)).")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testNumericNumber() {
        let json = """
            {"a":-2,"b":"-1","c":0,"d":"1","e":"2", "f":127,"g":"128","h":129,"i":"400","j":"500"}
        """

        do {
            let model = try TestNumericNumber.decodeJSON(json.trim().toData())
            XCTAssertTrue(model.a == -2, "Expected '-2' but found: \(String(describing: model.a)).")
            XCTAssertTrue(model.b == -1, "Expected '-1' but found: \(String(describing: model.b)).")
            XCTAssertTrue(model.c ==  0, "Expected '0' but found: \(String(describing: model.c)).")
            XCTAssertTrue(model.d ==  1, "Expected '1' but found: \(String(describing: model.d)).")
            XCTAssertTrue(model.e ==  2, "Expected '2' but found: \(String(describing: model.e)).")

            XCTAssertTrue(model.f == 127, "Expected '127' but found: \(String(describing: model.f)).")
            XCTAssertTrue(model.g == 128, "Expected '128' but found: \(String(describing: model.g)).")
            XCTAssertTrue(model.h == 129, "Expected '129' but found: \(String(describing: model.h)).")
            XCTAssertTrue(model.i == 400, "Expected '400' but found: \(String(describing: model.i)).")
            XCTAssertTrue(model.j == 500, "Expected '500' but found: \(String(describing: model.j)).")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testData() {
        let json = """
            {"a":"RndpQ29yZQ==","b":"FwiCore","c":"467769436f7265"}
        """

        do {
            let model = try TestData.decodeJSON(json.trim().toData())
            XCTAssertEqual(model.c, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model.c)).")  // Hex
            XCTAssertEqual(model.a, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model.a)).")  // Base64
            XCTAssertEqual(model.b, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model.b)).")  // String
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDate() {
        let date = Date()
        let time = date.timeIntervalSince1970
        
        let json = """
            {"a":\(time), "b":"\(time)", "c":"2017-12-23T16:54:30Z"}
        """

        do {
            let model = try TestDate.decodeJSON(json.trim().toData())
            XCTAssertEqual(model.a.timeIntervalSince1970, time, "Expected '\(time)' but found: \(String(describing: model.a)).")
            XCTAssertEqual(model.b.timeIntervalSince1970, time, "Expected '\(time)' but found: \(String(describing: model.b)).")
            XCTAssertEqual(model.c.timeIntervalSince1970, 1514048070.0, "Expected '\(1514048070)' but found: \(String(describing: model.c)).")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testURL() {
        let json = """
            {"a":"https://www.google.com"}
        """

        do {
            let model = try TestURL.decodeJSON(json.trim().toData())
            XCTAssertEqual(model.a.absoluteString, "https://www.google.com", "Expected '\("https://www.google.com")' but found: \(String(describing: model.a)).")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

// MARK: Test models
private struct BoolModel: Codable {
    let a: Bool
    let b: Bool
    let c: Bool

    var oA: Bool?
    var oB: Bool?
    var oC: Bool?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        a = try container.decode(.a)
        b = try container.decode(.b)
        c = try container.decode(.c)

        oA = try? container.decode(.oA)
        oB = try? container.decode(.oB)
        oC = try? container.decode(.oC)
    }
}
//private struct BoolModelPerformance: Codable {
//    let a: Bool
//    let b: Bool
//    let c: Bool
//
//    var oA: Bool?
//    var oB: Bool?
//    var oC: Bool?
//}

private struct TestFloatDouble: Codable {
    let a: Float
    var b: Float?
    let c: Double
    var d: Double?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        a = try container.decode(.a)
        b = try? container.decode(.b)
        c = try container.decode(.c)
        d = try? container.decode(.d)
    }
}

private struct TestNumericNumber: Codable {
    let a: Int
    let b: Int8
    let c: Int16
    let d: Int32
    let e: Int64

    let f: UInt
    let g: UInt8
    let h: UInt16
    let i: UInt32
    let j: UInt64

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        a = try container.decode(.a)
        b = try container.decode(.b)
        c = try container.decode(.c)
        d = try container.decode(.d)
        e = try container.decode(.e)

        f = try container.decode(.f)
        g = try container.decode(.g)
        h = try container.decode(.h)
        i = try container.decode(.i)
        j = try container.decode(.j)
    }
}

private struct TestData: Codable {
    let a: Data
    let b: Data
    let c: Data

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        a = try container.decode(.a)
        b = try container.decode(.b)
        c = try container.decode(.c)
    }
}

private struct TestDate: Codable {
    let a: Date
    let b: Date
    let c: Date

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        a = try container.decode(.a)
        b = try container.decode(.b)
        c = try container.decode(.c)
    }
}

private struct TestURL: Codable {
    let a: URL

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
////        a = try container.decode(.a)
//    }
}
