//  Project name: FwiCore
//  File name   : JSONMapperTest.swift
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
    var url: NSURL?
}

class Test: NSObject, FwiJSONModel {


    var a: Int = 0
    var z: URLTest?
    var d: [String: AnyObject]?
    var m: [String: URLTest]?
    var arr: [URLTest]?
    var arrNormal: [Int]?
    var arrString: [String]?
    var date: NSDate?
    var dateStr: NSDate?

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


class MapperTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let dict = ["test1": 5,
                    "test2": ["url": "https://www.google.com/?gws_rd=ssl"],
                    "test3" : ["testDict" : "abc"],
                    "test4": ["key" : ["url": "https://www.google.com/?gws_rd=ssl"]],
                    "test5": [["url": "https://www.google.com/?gws_rd=ssl"],
                        ["url": "https://www.google.com/?gws_rd=ssl"],
                        ["url": "https://www.google.com/?gws_rd=ssl"]],
                    "test6": [2, 4, 6],
                    "test7": ["adad", "dadada", "duadgaud"],
                    "test8": 1464768697,
                    "test9": "2012-10-01T094500GMT"

        ]

//        let c = JSONMapper1.mapClassWithDictionary(Test.self, dict: dict).object

        var c = Test()
        let error = FwiJSONMapper.mapObjectToModel(dict, model: &c)


        let dict1 = FwiJSONMapper.toDictionary(c)
        print(dict1)

    }

}
