//  Project name: FwiCore
//  File name   : ReflectorTests.swift
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


enum Compass: Int {
    case North = 0
    case South
    case East
    case West
}

struct Struct1 {
}


class Test1 {
    var value1 = 0
    var value2: UInt = 0
    var value3: Int?
    var value4: UInt?
    var value5: NSNumber?
}

@objc(Test2)
class Test2: NSObject {
    var object1: String?
    var object2: NSData?
    var object3: NSDate?
    var object4: NSURL?
}


class ReflectorTests: XCTestCase {


    // MARK: Class's properties


    // MARK: Initialize test case
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }


    // MARK: Test logics
    func testOptional() {
        let intValue: Int? = 100
        var r = Reflector(mirrorName: "intValue", mirrorValue: intValue)
        XCTAssertTrue(r.isOptional, "Expected true but found \(r.isOptional).")
        XCTAssertEqual(r.propertyName, "intValue", "Expected \"intValue\" but found \"\(r.propertyName)\".")
        XCTAssertTrue(r.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \"\(r.primitiveType)\".")

        let uintValue: UInt? = 100
        r = Reflector(mirrorName: "uintValue", mirrorValue: uintValue)
        XCTAssertTrue(r.primitiveType == UInt.self, "Expected \"\(UInt.self)\" but found \"\(r.primitiveType)\".")

        let floatValue: Float? = 100.0
        r = Reflector(mirrorName: "floatValue", mirrorValue: floatValue)
        XCTAssertTrue(r.primitiveType == Float.self, "Expected \"\(Float.self)\" but found \"\(r.primitiveType)\".")

        let doubleValue: Double? = 100.0
        r = Reflector(mirrorName: "doubleValue", mirrorValue: doubleValue)
        XCTAssertTrue(r.primitiveType == Double.self, "Expected \"\(Double.self)\" but found \"\(r.primitiveType)\".")

        let boolValue: Bool? = true
        r = Reflector(mirrorName: "boolValue", mirrorValue: boolValue)
        XCTAssertTrue(r.primitiveType == Bool.self, "Expected \"\(Bool.self)\" but found \"\(r.primitiveType)\".")

        let characterValue: Character? = "C"
        r = Reflector(mirrorName: "characterValue", mirrorValue: characterValue)
        XCTAssertTrue(r.primitiveType == Character.self, "Expected \"\(Character.self)\" but found \"\(r.primitiveType)\".")

        let stringValue: String? = "Some value."
        r = Reflector(mirrorName: "stringValue", mirrorValue: stringValue)
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")

        let nsstringValue: NSString? = "Some value."
        r = Reflector(mirrorName: "nsstringValue", mirrorValue: nsstringValue)
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")
    }

    func testNonOptional() {
        let stringValue = "Some value."
        var r = Reflector(mirrorName: "value", mirrorValue: stringValue)
        XCTAssertFalse(r.isOptional, "Expected false but found \(r.isOptional).")
        XCTAssertEqual(r.propertyName, "value", "Expected \"value\" but found \"\(r.propertyName)\".")
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")

        let nsstringValue: NSString = "Some value."
        r = Reflector(mirrorName: "nsstringValue", mirrorValue: nsstringValue)
        XCTAssertTrue(r.primitiveType == String.self, "Expected \"\(String.self)\" but found \"\(r.primitiveType)\".")
    }

    func testIsEnum() {
        let enumCompass = Compass.North
        print(String(reflecting: Compass.self))
        var r = Reflector(mirrorName: "enumCompass", mirrorValue: enumCompass)
        XCTAssertTrue(r.isEnum, "Expected true but found \(r.isEnum).")

        let m = iterateEnum(Compass)
        m.forEach({print($0)})
        let optionalEnumCompass: Compass? = Compass.North
        r = Reflector(mirrorName: "optionalEnumCompass", mirrorValue: optionalEnumCompass)
        XCTAssertTrue(r.isEnum, "Expected true but found \(r.isEnum).")
    }


    func iterateEnum<T: Hashable>(_: T.Type) -> AnyGenerator<T> {
        var i = 0
        return AnyGenerator {
            let next = withUnsafePointer(&i) { UnsafePointer<T>($0).memory }
            i += 1
            return next.hashValue == i ? next : nil
        }
    }

    func testIsPrimitive() {
        let value = 10
        var r = Reflector(mirrorName: "value", mirrorValue: value)
        XCTAssertTrue(r.isPrimitive, "Expected true but found \(r.isPrimitive).")

        let optionalValue: Int? = 10
        r = Reflector(mirrorName: "optionalValue", mirrorValue: optionalValue)
        XCTAssertTrue(r.isPrimitive, "Expected true but found \(r.isPrimitive).")
    }

    func testIsTuple() {
        let value1 = ("first", "second")
        let value2 = (first: "first", second: "second")
        var r1 = Reflector(mirrorName: "value1", mirrorValue: value1)
        var r2 = Reflector(mirrorName: "value2", mirrorValue: value2)
        XCTAssertTrue(r1.isTuple, "Expected true but found \(r1.isTuple).")
        XCTAssertTrue(r2.isTuple, "Expected true but found \(r2.isTuple).")

        let optionalValue1: (String, String)? = ("first", "second")
        let optionalValue2: (first: String, second: String)? = (first: "first", second: "second")
        r1 = Reflector(mirrorName: "optionalValue1", mirrorValue: optionalValue1)
        r2 = Reflector(mirrorName: "optionalValue2", mirrorValue: optionalValue2)
        XCTAssertTrue(r1.isTuple, "Expected true but found \(r1.isTuple).")
        XCTAssertTrue(r2.isTuple, "Expected true but found \(r2.isTuple).")
    }

    func testIsClass() {
        // Test class without super class
        let clazz1 = Test1()
        var r = Reflector(mirrorName: "clazz", mirrorValue: clazz1)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")

        let optionalClazz1: Test1? = Test1()
        r = Reflector(mirrorName: "optionalClazz1", mirrorValue: optionalClazz1)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")

        // Test class with super class
        let clazz2 = Test2()
        r = Reflector(mirrorName: "clazz2", mirrorValue: clazz2)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")

        let optionalClazz2: Test2? = Test2()
        r = Reflector(mirrorName: "optionalClazz2", mirrorValue: optionalClazz2)
        XCTAssertTrue(r.isClass, "Expected true but found \(r.isClass).")
    }

    func testIsObject() {
        // Test class without super class
        let clazz1 = Test1()
        var r = Reflector(mirrorName: "clazz", mirrorValue: clazz1)
        XCTAssertFalse(r.isObject, "Expected true but found \(r.isObject).")

        let optionalClazz1: Test1? = Test1()
        r = Reflector(mirrorName: "optionalClazz1", mirrorValue: optionalClazz1)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")


        // Test class with super class
        let clazz2 = Test2()
        r = Reflector(mirrorName: "clazz2", mirrorValue: clazz2)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")

        let optionalClazz2: Test2? = Test2()
        r = Reflector(mirrorName: "optionalClazz2", mirrorValue: optionalClazz2)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
    }

    func testIsStruct() {
        let struct1 = Struct1()
        var r = Reflector(mirrorName: "struct1", mirrorValue: struct1)
        XCTAssertTrue(r.isStruct, "Expected true but found \(r.isStruct).")

        let struct2: Struct1? = Struct1()
        r = Reflector(mirrorName: "struct2", mirrorValue: struct2)
        XCTAssertTrue(r.isStruct, "Expected true but found \(r.isStruct).")
    }

    func testIsSet() {
        // Test NSSet ObjC
        let setLetters = NSSet()
        var r = Reflector(mirrorName: "setLetters", mirrorValue: setLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let optionalSetLetters: NSSet? = NSSet()
        r = Reflector(mirrorName: "optionalSetLetters", mirrorValue: optionalSetLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let mutableSetLetters = NSMutableSet()
        r = Reflector(mirrorName: "mutableSetLetters", mirrorValue: mutableSetLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let optionalMutableSetLetters: NSMutableSet? = NSMutableSet()
        r = Reflector(mirrorName: "optionalMutableSetLetters", mirrorValue: optionalMutableSetLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        // Test Set Swift
        var letters = Set<String>()
        r = Reflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        letters = ["Rock", "Classical", "Hip hop"]
        r = Reflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let optionalLetters: Set<String>? = Set<String>()
        r = Reflector(mirrorName: "optionalLetters", mirrorValue: optionalLetters)
        XCTAssertTrue(r.isSet, "Expected true but found \(r.isSet).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let setObject = Set<Test2>()
        r = Reflector(mirrorName: "setObject", mirrorValue: setObject)
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test2.self, "Expected \"\(Test2.self)\" but found \(r.collectionType?.classType).")

        // Optional Test2 will never happen due to compile time error
//        let setOptionalObject = Set<Test2?>()
    }

    func testIsCollection() {
        // Test NSArray ObjC
        let arrayLetters = NSArray()
        var r = Reflector(mirrorName: "arrayLetters", mirrorValue: arrayLetters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let optionalArrayLetters: NSArray? = NSArray()
        r = Reflector(mirrorName: "optionalArrayLetters", mirrorValue: optionalArrayLetters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let mutableArrayLetters = NSMutableArray()
        r = Reflector(mirrorName: "mutableArrayLetters", mirrorValue: mutableArrayLetters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        let optionalMutableArrayLetters: NSMutableArray? = NSMutableArray()
        r = Reflector(mirrorName: "optionalMutableArrayLetters", mirrorValue: optionalMutableArrayLetters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.collectionType?.classType).")

        // Test Array Swift
        var letters = Array<String>()
        r = Reflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        letters = ["Rock", "Classical", "Hip hop"]
        r = Reflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let optionalLetters1: Array<String>? = Array<String>()
        r = Reflector(mirrorName: "optionalLetters1", mirrorValue: optionalLetters1)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let optionalLetters2: [String]? = Array<String>()
        r = Reflector(mirrorName: "optionalLetters2", mirrorValue: optionalLetters2)
        XCTAssertTrue(r.isCollection, "Expected true but found \(r.isCollection).")
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.collectionType?.isPrimitive == true, "Expected true but found \(r.collectionType?.isPrimitive).")
        XCTAssertTrue(r.collectionType?.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.collectionType?.primitiveType).")

        let arrayTest1 = [Test1]()
        r = Reflector(mirrorName: "arrayTest1", mirrorValue: arrayTest1)
        XCTAssertTrue(r.collectionType?.isObject == false, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test1.self, "Expected \"\(Test1.self)\" but found \(r.collectionType?.classType).")

        let arrayOptionalTest1 = [Test1?]()
        r = Reflector(mirrorName: "arrayOptionalTest1", mirrorValue: arrayOptionalTest1)
        XCTAssertTrue(r.collectionType?.isObject == false, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test1.self, "Expected \"\(Test1.self)\" but found \(r.collectionType?.classType).")

        let arrayTest2 = [Test2]()
        r = Reflector(mirrorName: "arrayTest2", mirrorValue: arrayTest2)
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test2.self, "Expected \"\(Test2.self)\" but found \(r.collectionType?.classType).")

        let arrayOptionalTest2 = [Test2?]()
        r = Reflector(mirrorName: "arrayOptionalTest2", mirrorValue: arrayOptionalTest2)
        XCTAssertTrue(r.collectionType?.isObject == true, "Expected true but found \(r.collectionType?.isObject).")
        XCTAssertTrue(r.collectionType?.classType == Test2.self, "Expected \"\(Test2.self)\" but found \(r.collectionType?.classType).")
    }

    func testIsDictionary() {
        // Test NSDictionary ObjC
        let dictionaryLetters = NSDictionary()
        var r = Reflector(mirrorName: "arrayLetters", mirrorValue: dictionaryLetters)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isObject == true, "Expected true but found \(r.dictionaryType?.key.isObject).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.key.classType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.value.classType).")

        let optionalDictionaryLetters: NSDictionary? = NSDictionary()
        r = Reflector(mirrorName: "optionalDictionaryLetters", mirrorValue: optionalDictionaryLetters)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isObject == true, "Expected true but found \(r.dictionaryType?.key.isObject).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.key.classType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.value.classType).")

        let mutableDictionaryLetters = NSMutableDictionary()
        r = Reflector(mirrorName: "mutableDictionaryLetters", mirrorValue: mutableDictionaryLetters)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isObject == true, "Expected true but found \(r.dictionaryType?.key.isObject).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.key.classType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.value.classType).")

        let optionalMutableDictionaryLetters: NSMutableDictionary? = NSMutableDictionary()
        r = Reflector(mirrorName: "optionalMutableDictionaryLetters", mirrorValue: optionalMutableDictionaryLetters)
        XCTAssertTrue(r.isObject, "Expected true but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isObject == true, "Expected true but found \(r.dictionaryType?.key.isObject).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.key.classType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == NSObject.self, "Expected \"\(NSObject.self)\" but found \(r.dictionaryType?.value.classType).")

        // Test Dictionary Swift
        var letters = Dictionary<String, String>()
        r = Reflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isPrimitive == true, "Expected true but found \(r.dictionaryType?.value.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.value.primitiveType).")

        letters = ["Rock":"Rock", "Classical":"Classical", "Hip hop":"Hip hop"]
        r = Reflector(mirrorName: "letters", mirrorValue: letters)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isPrimitive == true, "Expected true but found \(r.dictionaryType?.value.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.value.primitiveType).")

        let optionalLetters1: Dictionary<String, String>? = Dictionary<String, String>()
        r = Reflector(mirrorName: "optionalLetters1", mirrorValue: optionalLetters1)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isPrimitive == true, "Expected true but found \(r.dictionaryType?.value.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.value.primitiveType).")

        let optionalLetters2: [String:String]? = ["Rock":"Rock", "Classical":"Classical", "Hip hop":"Hip hop"]
        r = Reflector(mirrorName: "optionalLetters2", mirrorValue: optionalLetters2)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isPrimitive == true, "Expected true but found \(r.dictionaryType?.value.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.value.primitiveType).")

        let dictionaryTest1 = [Int:Test1]()
        r = Reflector(mirrorName: "dictionaryTest1", mirrorValue: dictionaryTest1)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isClass == true, "Expected true but found \(r.dictionaryType?.value.isClass).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == false, "Expected false but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == Test1.self, "Expected \"\(Test1.self)\" but found \(r.dictionaryType?.value.classType).")

        let dictionaryOptionalTest1 = [String:Test1?]()
        r = Reflector(mirrorName: "dictionaryOptionalTest1", mirrorValue: dictionaryOptionalTest1)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isClass == true, "Expected true but found \(r.dictionaryType?.value.isClass).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == false, "Expected false but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == Test1.self, "Expected \"\(Test1.self)\" but found \(r.dictionaryType?.value.classType).")

        let dictionaryTest2 = [Int:Test2]()
        r = Reflector(mirrorName: "dictionaryTest2", mirrorValue: dictionaryTest2)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isClass == true, "Expected true but found \(r.dictionaryType?.value.isClass).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == Int.self, "Expected \"\(Int.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == Test2.self, "Expected \"\(Test2.self)\" but found \(r.dictionaryType?.value.classType).")

        let dictionaryOptionalTest2 = [String:Test2?]()
        r = Reflector(mirrorName: "dictionaryOptionalTest2", mirrorValue: dictionaryOptionalTest2)
        XCTAssertFalse(r.isObject, "Expected false but found \(r.isObject).")
        XCTAssertTrue(r.isDictionary, "Expected true but found \(r.isDictionary).")
        XCTAssertTrue(r.dictionaryType?.key.isPrimitive == true, "Expected true but found \(r.dictionaryType?.key.isPrimitive).")
        XCTAssertTrue(r.dictionaryType?.value.isClass == true, "Expected true but found \(r.dictionaryType?.value.isClass).")
        XCTAssertTrue(r.dictionaryType?.value.isObject == true, "Expected true but found \(r.dictionaryType?.value.isObject).")
        XCTAssertTrue(r.dictionaryType?.key.primitiveType == String.self, "Expected \"\(String.self)\" but found \(r.dictionaryType?.key.primitiveType).")
        XCTAssertTrue(r.dictionaryType?.value.classType == Test2.self, "Expected \"\(Test2.self)\" but found \(r.dictionaryType?.value.classType).")
    }


//    // MARK: Test performances
//    func testPerformanceExample() {
//        self.measureBlock {
//        }
//    }
}
