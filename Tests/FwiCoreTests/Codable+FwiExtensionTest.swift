//  File name   : Codable+FwiExtensionTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 1/26/19
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

//fileprivate enum TestEnum: String, Codable {
//    case firstName = "first_name"
//    case lastName = "last_name"
//}
//
//fileprivate struct TestEnum: Codable {
//
//    var name: String?
//    var last: String?
//    var data: Data?
//}
//
//fileprivate struct TestModel2: Codable {
//    var age: UInt?
//    var name: String?
//    var last: String?
//
//    var enumValue: TestEnum?
//    var object: [String:String]?
//
//    var model: TestEnum?
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        //        container.parse(&age, key: .age)
//        //        container.parse(&name, key: .name)
//        //        container.parse(&last, key: .last)
//        //
//        //        container.parse(&object, key: .object)
//        //        container.parse(&enumValue, key: .enumValue)
//        //
//        //        container.parse(&model, key: .model)
//    }
//}

final class CodableFwiExtensionTest: XCTestCase {
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test Cases
//    func testCodable() {
//        let model = try? TestModel2.decodeJSON(json2.toData())
//        XCTAssertEqual(model?.age, 10, "Expected '10' but found: \(String(describing: model?.age)).")
//        XCTAssertEqual(model?.name, "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model?.name)).")
//        XCTAssertEqual(model?.last, "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model?.last)).")
//
//        XCTAssertEqual(model?.enumValue, TestEnum.lastName, "Expected '\(TestEnum.lastName)' but found: \(String(describing: model?.enumValue)).")
//        XCTAssertEqual(model?.object ?? [:], ["name":"Phuc","last":"Tran"], "Expected '\(["name":"Phuc","last":"Tran"])' but found: \(String(describing: model?.object)).")
//
//        XCTAssertNotNil(model?.model, "Expected not nil but found: \(String(describing: model)).")
//        XCTAssertEqual(model?.model?.name, "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model?.name)).")
//        XCTAssertEqual(model?.model?.data, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model?.model?.data)).")
//    }
//
//    func testEncodeJSON() {
//        var model = TestEnum()
//        model.name = "FwiCore"
//        model.last = "FwiCore"
//        model.data = "FwiCore".toData()
//
//        let data = try? model.encodeJSON()
//        XCTAssertNotNil(data, "Expected not nil but found: \(String(describing: data)).")
//        XCTAssertEqual(data?.toString(), json, "Expected '\(json)' but found: \(String(describing: data?.toString())).")
//    }
//
//    func testDecodeJSON() {
//        let model = try? TestEnum.decodeJSON(json.toData())
//        XCTAssertNotNil(model, "Expected not nil but found: \(String(describing: model)).")
//        XCTAssertEqual(model?.name, "FwiCore", "Expected 'FwiCore' but found: \(String(describing: model?.name)).")
//        XCTAssertEqual(model?.data, "FwiCore".toData(), "Expected '\(String(describing: "FwiCore".toData()))' but found: \(String(describing: model?.data)).")
//    }
    
    // MARK: Performance test cases
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    /// Class's private properties.
    private let json = """
        {"name":"FwiCore","last":"FwiCore","data":"RndpQ29yZQ=="}
    """.trim()

    private let json2 = """
        {"name":"FwiCore","last":"FwiCore","age":"10","enumValue":"last_name","object":{"name":"Phuc","last":"Tran"}, "model":{"name":"FwiCore","last":"FwiCore","data":"RndpQ29yZQ=="}}
    """.trim()
}
