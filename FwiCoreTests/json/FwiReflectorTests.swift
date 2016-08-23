//  Project name: FwiCore
//  File name   : FwiReflectorTests.swift
//
//  Author      : Phuc, Tran Huu
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


enum Compass1: Int {
    case north = 0
    case south
    case east
    case west
}
public enum Compass2: Int {
    case north = 0
    case south
    case east
    case west
}
//private enum Compass3: Int {
//    case North = 0
//    case South
//    case East
//    case West
//}

struct Struct1 {
}
public struct Struct2 {
}
//private struct Struct3 {
//}

class Test1 {
    var value1 = 0
    var value2: UInt = 0
    var value3: Int?
    var value4: UInt?
    var value5: NSNumber?
}
open class Test2 {
    var value1 = 0
    var value2: UInt = 0
    var value3: Int?
    var value4: UInt?
    var value5: NSNumber?
}
//private class Test3 {
//    var value1 = 0
//    var value2: UInt = 0
//    var value3: Int?
//    var value4: UInt?
//    var value5: NSNumber?
//}

@objc(Test4)
class Test4: NSObject {
    var object1: String?
    var object2: Data?
    var object3: Date?
    var object4: URL?
}
@objc(Test5)
open class Test5: NSObject {
    var object1: String?
    var object2: Data?
    var object3: Date?
    var object4: URL?
}
//@objc(Test6)
//private class Test6: NSObject {
//    var object1: String?
//    var object2: NSData?
//    var object3: NSDate?
//    var object4: NSURL?
//}




class FwiReflectorTests: XCTestCase {


    // MARK: Class's properties


    // MARK: Initialize test case
    override func setUp() {
        super.setUp()
        FwiLog("\(#file)")
    }
    override func tearDown() {
        super.tearDown()
    }


    // MARK: Test logics
    func testNonOptional() {
        let intValue: Int = 100
        var r = FwiReflector(mirrorName: "intValue", mirrorValue: intValue)
        XCTAssertFalse(r.isOptional, "Expected true but found \(r.isOptional).")
        XCTAssertEqual(r.propertyName, "intValue", "Expected \"intValue\" but found \"\(r.propertyName)\".")
        XCTAssertTrue(r.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \"\(r.primitiveType)\".")

        let uintValue: UInt = 100
        r = FwiReflector(mirrorName: "uintValue", mirrorValue: uintValue)
        XCTAssertTrue(r.primitiveType == UInt.self, "Expected \"\(UInt.self)\" but found \"\(r.primitiveType)\".")

        let floatValue: Float = 100.0
        r = FwiReflector(mirrorName: "floatValue", mirrorValue: floatValue)
        XCTAssertTrue(r.primitiveType == Float.self, "Expected \"\(Float.self)\" but found \"\(r.primitiveType)\".")

        let doubleValue: Double = 100.0
        r = FwiReflector(mirrorName: "doubleValue", mirrorValue: doubleValue)
        XCTAssertTrue(r.primitiveType == Double.self, "Expected \"\(Double.self)\" but found \"\(r.primitiveType)\".")

        let boolValue: Bool = true
        r = FwiReflector(mirrorName: "boolValue", mirrorValue: boolValue)
        XCTAssertTrue(r.primitiveType == Bool.self, "Expected \"\(Bool.self)\" but found \"\(r.primitiveType)\".")

        let characterValue: Character = "C"
        r = FwiReflector(mirrorName: "characterValue", mirrorValue: characterValue)
        XCTAssertTrue(r.primitiveType == Character.self, "Expected \"\(Character.self)\" but found \"\(r.primitiveType)\".")

        let stringValue = "Some value."
        r = FwiReflector(mirrorName: "value", mirrorValue: stringValue)
        XCTAssertFalse(r.isOptional, "Expected false but found \(r.isOptional).")
        XCTAssertEqual(r.propertyName, "value", "Expected \"value\" but found \"\(r.propertyName)\".")
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")

        let nsstringValue: NSString = "Some value."
        r = FwiReflector(mirrorName: "nsstringValue", mirrorValue: nsstringValue)
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")

        let nsMutableStringValue = NSMutableString(format: "%s", "Some value.")
        r = FwiReflector(mirrorName: "nsMutableStringValue", mirrorValue: nsMutableStringValue)
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")
    }

    func testOptional() {
        let intValue: Int? = 100
        var r = FwiReflector(mirrorName: "intValue", mirrorValue: intValue)
        XCTAssertTrue(r.isOptional, "Expected true but found \(r.isOptional).")
        XCTAssertEqual(r.propertyName, "intValue", "Expected \"intValue\" but found \"\(r.propertyName)\".")
        XCTAssertTrue(r.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \"\(r.primitiveType)\".")

        let uintValue: UInt? = 100
        r = FwiReflector(mirrorName: "uintValue", mirrorValue: uintValue)
        XCTAssertTrue(r.primitiveType == UInt.self, "Expected \"\(UInt.self)\" but found \"\(r.primitiveType)\".")

        let floatValue: Float? = 100.0
        r = FwiReflector(mirrorName: "floatValue", mirrorValue: floatValue)
        XCTAssertTrue(r.primitiveType == Float.self, "Expected \"\(Float.self)\" but found \"\(r.primitiveType)\".")

        let doubleValue: Double? = 100.0
        r = FwiReflector(mirrorName: "doubleValue", mirrorValue: doubleValue)
        XCTAssertTrue(r.primitiveType == Double.self, "Expected \"\(Double.self)\" but found \"\(r.primitiveType)\".")

        let boolValue: Bool? = true
        r = FwiReflector(mirrorName: "boolValue", mirrorValue: boolValue)
        XCTAssertTrue(r.primitiveType == Bool.self, "Expected \"\(Bool.self)\" but found \"\(r.primitiveType)\".")

        let characterValue: Character? = "C"
        r = FwiReflector(mirrorName: "characterValue", mirrorValue: characterValue)
        XCTAssertTrue(r.primitiveType == Character.self, "Expected \"\(Character.self)\" but found \"\(r.primitiveType)\".")

        let stringValue: String? = "Some value."
        r = FwiReflector(mirrorName: "stringValue", mirrorValue: stringValue)
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")

        let nsstringValue: NSString? = "Some value."
        r = FwiReflector(mirrorName: "nsstringValue", mirrorValue: nsstringValue)
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")

        let nsMutableStringValue: NSMutableString? = NSMutableString(format: "%s", "Some value.")
        r = FwiReflector(mirrorName: "nsMutableStringValue", mirrorValue: nsMutableStringValue)
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")
    }

    func testIsEnum() {
        let enumCompass = Compass1.north
        var r = FwiReflector(mirrorName: "enumCompass", mirrorValue: enumCompass)
        XCTAssertTrue(r.isEnum, "Expected true but found \(r.isEnum).")

        let optionalEnumCompass: Compass1? = Compass1.north
        r = FwiReflector(mirrorName: "optionalEnumCompass", mirrorValue: optionalEnumCompass)
        XCTAssertTrue(r.isEnum, "Expected true but found \(r.isEnum).")
    }

    func testIsPrimitive() {
        let value = 10
        var r = FwiReflector(mirrorName: "value", mirrorValue: value)
        XCTAssertTrue(r.isPrimitive, "Expected true but found \(r.isPrimitive).")

        let optionalValue: Int? = 10
        r = FwiReflector(mirrorName: "optionalValue", mirrorValue: optionalValue)
        XCTAssertTrue(r.isPrimitive, "Expected true but found \(r.isPrimitive).")
    }

    func testIsTuple() {
        let value1 = ("first", "second")
        let value2 = (first: "first", second: "second")
        var r1 = FwiReflector(mirrorName: "value1", mirrorValue: value1)
        var r2 = FwiReflector(mirrorName: "value2", mirrorValue: value2)
        XCTAssertTrue(r1.isTuple, "Expected true but found \(r1.isTuple).")
        XCTAssertTrue(r2.isTuple, "Expected true but found \(r2.isTuple).")

        let optionalValue1: (String, String)? = ("first", "second")
        let optionalValue2: (first: String, second: String)? = (first: "first", second: "second")
        r1 = FwiReflector(mirrorName: "optionalValue1", mirrorValue: optionalValue1)
        r2 = FwiReflector(mirrorName: "optionalValue2", mirrorValue: optionalValue2)
        XCTAssertTrue(r1.isTuple, "Expected true but found \(r1.isTuple).")
        XCTAssertTrue(r2.isTuple, "Expected true but found \(r2.isTuple).")
    }

    func testIsClass() {
        // Test class without super class
        let clazz1 = Test1()
        let optionalClazz1: Test1? = Test1()
        var r = FwiReflector(mirrorName: "clazz1", mirrorValue: clazz1)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")
        r = FwiReflector(mirrorName: "optionalClazz1", mirrorValue: optionalClazz1)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")

        let clazz2 = Test2()
        let optionalClazz2: Test2? = Test2()
        r = FwiReflector(mirrorName: "clazz2", mirrorValue: clazz2)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")
        r = FwiReflector(mirrorName: "optionalClazz2", mirrorValue: optionalClazz2)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")

//        let clazz3 = Test3()
//        let optionalClazz3: Test3? = Test3()
//        r = FwiReflector(mirrorName: "clazz3", mirrorValue: clazz3)
//        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")
//        r = FwiReflector(mirrorName: "optionalClazz3", mirrorValue: optionalClazz3)
//        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")

        // Test class with super class
        let clazz4 = Test4()
        let optionalClazz4: Test4? = Test4()
        r = FwiReflector(mirrorName: "clazz4", mirrorValue: clazz4)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")
        r = FwiReflector(mirrorName: "optionalClazz4", mirrorValue: optionalClazz4)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")

        let clazz5 = Test5()
        let optionalClazz5: Test5? = Test5()
        r = FwiReflector(mirrorName: "clazz5", mirrorValue: clazz5)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")
        r = FwiReflector(mirrorName: "optionalClazz5", mirrorValue: optionalClazz5)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")

//        let clazz6 = Test6()
//        let optionalClazz6: Test6? = Test6()
//        r = FwiReflector(mirrorName: "clazz6", mirrorValue: clazz6)
//        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")
//        r = FwiReflector(mirrorName: "optionalClazz6", mirrorValue: optionalClazz6)
//        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")
    }

    func testIsObject() {
        // Test class without super class
        let clazz1 = Test1()
        let optionalClazz1: Test1? = Test1()
        var r = FwiReflector(mirrorName: "clazz1", mirrorValue: clazz1)
        XCTAssertFalse(r.isObject, "Expected true but found \(r.isObject).")
        r = FwiReflector(mirrorName: "optionalClazz1", mirrorValue: optionalClazz1)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")


        // Test class with super class
        let clazz4 = Test4()
        let optionalClazz4: Test4? = Test4()
        r = FwiReflector(mirrorName: "clazz4", mirrorValue: clazz4)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        r = FwiReflector(mirrorName: "optionalClazz4", mirrorValue: optionalClazz4)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
    }

    func testIsStruct() {
        let struct1 = Struct1()
        let optionalStruct1: Struct1? = Struct1()
        var r = FwiReflector(mirrorName: "struct1", mirrorValue: struct1)
        XCTAssertTrue(r.isStruct, "Expected true but found \(r.isStruct).")
        r = FwiReflector(mirrorName: "optionalStruct1", mirrorValue: optionalStruct1)
        XCTAssertTrue(r.isStruct, "Expected true but found \(r.isStruct).")

        let struct2 = Struct2()
        let optionalStruct2: Struct2? = Struct2()
        r = FwiReflector(mirrorName: "struct2", mirrorValue: struct2)
        XCTAssertTrue(r.isStruct, "Expected true but found \(r.isStruct).")
        r = FwiReflector(mirrorName: "optionalStruct2", mirrorValue: optionalStruct2)
        XCTAssertTrue(r.isStruct, "Expected true but found \(r.isStruct).")

//        let struct3 = Struct3()
//        let optionalStruct3: Struct3? = Struct3()
//        r = FwiReflector(mirrorName: "struct3", mirrorValue: struct3)
//        XCTAssertTrue(r.isStruct, "Expected true but found \(r.isStruct).")
//        r = FwiReflector(mirrorName: "optionalStruct3", mirrorValue: optionalStruct3)
//        XCTAssertTrue(r.isStruct, "Expected true but found \(r.isStruct).")
    }

    func testIsSet() {
        // Test NSSet ObjC
        let setLetters = NSSet()
        var r = FwiReflector(mirrorName: "setLetters", mirrorValue: setLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let optionalSetLetters: NSSet? = NSSet()
        r = FwiReflector(mirrorName: "optionalSetLetters", mirrorValue: optionalSetLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let mutableSetLetters = NSMutableSet()
        r = FwiReflector(mirrorName: "mutableSetLetters", mirrorValue: mutableSetLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let optionalMutableSetLetters: NSMutableSet? = NSMutableSet()
        r = FwiReflector(mirrorName: "optionalMutableSetLetters", mirrorValue: optionalMutableSetLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        // Test Set Swift
        var letters = Set<String>()
        r = FwiReflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        letters = ["Rock", "Classical", "Hip hop"]
        r = FwiReflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let optionalLetters: Set<String>? = Set<String>()
        r = FwiReflector(mirrorName: "optionalLetters", mirrorValue: optionalLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let setObject = Set<Test4>()
        r = FwiReflector(mirrorName: "setObject", mirrorValue: setObject)
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test4.self, "Expected \"\(Test4.self)\" but found \(r.collectionType?.classType).")

        // Optional Test2 will never happen due to compile time error
//        let setOptionalObject = Set<Test2?>()
    }

    func testIsCollection() {
        // Test NSArray ObjC
        let arrayLetters = NSArray()
        var r = FwiReflector(mirrorName: "arrayLetters", mirrorValue: arrayLetters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let optionalArrayLetters: NSArray? = NSArray()
        r = FwiReflector(mirrorName: "optionalArrayLetters", mirrorValue: optionalArrayLetters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let mutableArrayLetters = NSMutableArray()
        r = FwiReflector(mirrorName: "mutableArrayLetters", mirrorValue: mutableArrayLetters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let optionalMutableArrayLetters: NSMutableArray? = NSMutableArray()
        r = FwiReflector(mirrorName: "optionalMutableArrayLetters", mirrorValue: optionalMutableArrayLetters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        // Test Array Swift
        var letters = Array<String>()
        r = FwiReflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        letters = ["Rock", "Classical", "Hip hop"]
        r = FwiReflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let optionalLetters1: Array<String>? = Array<String>()
        r = FwiReflector(mirrorName: "optionalLetters1", mirrorValue: optionalLetters1)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let optionalLetters2: [String]? = Array<String>()
        r = FwiReflector(mirrorName: "optionalLetters2", mirrorValue: optionalLetters2)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let arrayTest1 = [Test1]()
        let arrayOptionalTest1 = [Test1?]()
        r = FwiReflector(mirrorName: "arrayTest1", mirrorValue: arrayTest1)
        XCTAssertTrue(r.collectionType?.isObject == false, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test1.self, "Expected \"\(Test1.self)\" but found \(r.collectionType?.classType).")
        r = FwiReflector(mirrorName: "arrayOptionalTest1", mirrorValue: arrayOptionalTest1)
        XCTAssertTrue(r.collectionType?.isObject == false, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test1.self, "Expected \"\(Test1.self)\" but found \(r.collectionType?.classType).")

        let arrayTest2 = [Test4]()
        let arrayOptionalTest2 = [Test4?]()
        r = FwiReflector(mirrorName: "arrayTest2", mirrorValue: arrayTest2)
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test4.self, "Expected \"\(Test4.self)\" but found \(r.collectionType?.classType).")
        r = FwiReflector(mirrorName: "arrayOptionalTest2", mirrorValue: arrayOptionalTest2)
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test4.self, "Expected \"\(Test4.self)\" but found \(r.collectionType?.classType).")
    }

    func testIsDictionary() {
        // Test NSDictionary ObjC
        let dictionaryLetters = NSDictionary()
        var r = FwiReflector(mirrorName: "arrayLetters", mirrorValue: dictionaryLetters)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isObject == true, "Expected true but found \(r.dictionaryType?.key.isObject).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.key.classType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.value.classType).")

        let optionalDictionaryLetters: NSDictionary? = NSDictionary()
        r = FwiReflector(mirrorName: "optionalDictionaryLetters", mirrorValue: optionalDictionaryLetters)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isObject == true, "Expected true but found \(r.dictionaryType?.key.isObject).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.key.classType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.value.classType).")

        let mutableDictionaryLetters = NSMutableDictionary()
        r = FwiReflector(mirrorName: "mutableDictionaryLetters", mirrorValue: mutableDictionaryLetters)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isObject == true, "Expected true but found \(r.dictionaryType?.key.isObject).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.key.classType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.value.classType).")

        let optionalMutableDictionaryLetters: NSMutableDictionary? = NSMutableDictionary()
        r = FwiReflector(mirrorName: "optionalMutableDictionaryLetters", mirrorValue: optionalMutableDictionaryLetters)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isObject == true, "Expected true but found \(r.dictionaryType?.key.isObject).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.key.classType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.value.classType).")

        // Test Dictionary Swift
        var letters = Dictionary<String, String>()
        r = FwiReflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isPrimitive == true, "Expected true but found \(r.dictionaryType?.value.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.value.primitiveType).")

        letters = ["Rock":"Rock", "Classical":"Classical", "Hip hop":"Hip hop"]
        r = FwiReflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isPrimitive == true, "Expected true but found \(r.dictionaryType?.value.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.value.primitiveType).")

        let optionalLetters1: Dictionary<String, String>? = Dictionary<String, String>()
        r = FwiReflector(mirrorName: "optionalLetters1", mirrorValue: optionalLetters1)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isPrimitive == true, "Expected true but found \(r.dictionaryType?.value.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.value.primitiveType).")

        let optionalLetters2: [String:String]? = ["Rock":"Rock", "Classical":"Classical", "Hip hop":"Hip hop"]
        r = FwiReflector(mirrorName: "optionalLetters2", mirrorValue: optionalLetters2)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isPrimitive == true, "Expected true but found \(r.dictionaryType?.value.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.value.primitiveType).")

        let dictionaryTest1 = [Int:Test1]()
        let dictionaryOptionalTest1 = [Int:Test1?]()
        r = FwiReflector(mirrorName: "dictionaryTest1", mirrorValue: dictionaryTest1)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isClass == true, "Expected true but found \(r.dictionaryType?.value.isClass).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == false, "Expected false but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == Test1.self, "Expected \"\(Test1.self)\" but found \(r.dictionaryType?.value.classType).")
        r = FwiReflector(mirrorName: "dictionaryOptionalTest1", mirrorValue: dictionaryOptionalTest1)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isClass == true, "Expected true but found \(r.dictionaryType?.value.isClass).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == false, "Expected false but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == Test1.self, "Expected \"\(Test1.self)\" but found \(r.dictionaryType?.value.classType).")

        let dictionaryTest2 = [Int:Test4]()
        let dictionaryOptionalTest2 = [Int:Test4?]()
        r = FwiReflector(mirrorName: "dictionaryTest2", mirrorValue: dictionaryTest2)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isClass == true, "Expected true but found \(r.dictionaryType?.value.isClass).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == Test4.self, "Expected \"\(Test4.self)\" but found \(r.dictionaryType?.value.classType).")
        r = FwiReflector(mirrorName: "dictionaryOptionalTest2", mirrorValue: dictionaryOptionalTest2)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isClass == true, "Expected true but found \(r.dictionaryType?.value.isClass).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == Test4.self, "Expected \"\(Test4.self)\" but found \(r.dictionaryType?.value.classType).")
    }


//    // MARK: Test performances
//    func testPerformanceExample() {
//        self.measureBlock {
//        }
//    }
}
