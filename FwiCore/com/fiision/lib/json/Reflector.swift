//  Project name: ZinioReader
//  File name   : Reflector.swift
//
//  Author      : Phuc Tran
//  Created date: 4/27/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Zinio Pro. All rights reserved.
//  --------------------------------------------------------------

import Foundation


@objc(Reflector)
public class Reflector: NSObject {


    // MARK: Class's constructors
    public override init() {
        super.init()
    }


    // MARK: Class's properties
    public lazy var isOptional: Bool = {
        if let style = self.mirrorType.displayStyle where style == .Optional {
            return true
        }
        return false
    }()

    public lazy var isEnum: Bool = {
        if !self.isOptional {
            if let style = self.mirrorType.displayStyle where style == .Enum {
                return true
            }
            return false
        }
        print("\(self.mirrorType.subjectType)")
        return false
    }()
    public lazy var isTuple: Bool = {
        if !self.isOptional {
            if let style = self.mirrorType.displayStyle where style == .Tuple {
                return true
            }
            return false
        }

        let type = self.extractType()
        return (type[type.startIndex] == "(" && type[type.endIndex.advancedBy(-1)] == ")")
    }()
    public lazy var isStruct: Bool = {
        if !self.isOptional {
            if let style = self.mirrorType.displayStyle where style == .Struct {
                return true
            }
            return false
        }

        return false
    }()

    public lazy var propertyName: String = {
        return self.mirrorName
    }()

    // Primitive type
    public lazy var isPrimitive: Bool = {
        let type = self.mirrorType.subjectType

        if !self.isOptional {
            if  type == Bool.self ||
                type == Int.self || type == Int8.self || type == Int16.self || type == Int32.self || type == Int64.self ||
                type == UInt.self || type == UInt8.self || type == UInt16.self || type == UInt32.self || type == UInt64.self ||
                type == Float.self || type == Float32.self || type == Float64.self || type == Float80.self ||
                type == Double.self ||
                type == Character.self || type == String.self || type == nsStringType || type == nsMutablestringType {
                return true
            }
        } else {
            if  type == Optional<Bool>.self ||
                type == Optional<Int>.self || type == Optional<Int8>.self || type == Optional<Int16>.self || type == Optional<Int32>.self || type == Optional<Int64>.self ||
                type == Optional<UInt>.self || type == Optional<UInt8>.self || type == Optional<UInt16>.self || type == Optional<UInt32>.self || type == Optional<UInt64>.self ||
                type == Optional<Float>.self || type == Optional<Float32>.self || type == Optional<Float64>.self || type == Optional<Float80>.self ||
                type == Optional<Double>.self ||
                type == Optional<Character>.self || type == Optional<String>.self || type == Optional<NSString>.self || type == Optional<NSMutableString>.self {
                return true
            }
        }
        return false
    }()
    public lazy var primitiveType: Any.Type? = {
        /* Condition validation */
        if !self.isPrimitive {
            return nil
        }
        let type = self.mirrorType.subjectType

        // Bool
        if type == Bool.self || type == Optional<Bool>.self {
            return Bool.self
        }

            // Int
        else if type == Int.self || type == Optional<Int>.self {
            return Int.self
        } else if type == Int8.self || type == Optional<Int8>.self {
            return Int8.self
        } else if type == Int16.self || type == Optional<Int16>.self {
            return Int16.self
        } else if type == Int32.self || type == Optional<Int32>.self {
            return Int32.self
        } else if type == Int64.self || type == Optional<Int64>.self {
            return Int64.self
        }

            // UInt
        else if type == UInt.self || type == Optional<UInt>.self {
            return UInt.self
        } else if type == UInt8.self || type == Optional<UInt8>.self {
            return UInt8.self
        } else if type == UInt16.self || type == Optional<UInt16>.self {
            return UInt16.self
        } else if type == UInt32.self || type == Optional<UInt32>.self {
            return UInt32.self
        } else if type == UInt64.self || type == Optional<UInt64>.self {
            return UInt64.self
        }

            // Float
        else if type == Float.self || type == Optional<Float>.self {
            return Float.self
        } else if type == Float32.self || type == Optional<Float32>.self {
            return Float32.self
        } else if type == Float64.self || type == Optional<Float64>.self {
            return Float64.self
        } else if type == Float80.self || type == Optional<Float80>.self {
            return Float80.self
        }

            // Double
        else if type == Double.self || type == Optional<Double>.self {
            return Double.self
        }

            // Character
        else if type == Character.self || type == Optional<Character>.self {
            return Character.self
        } else {
            return String.self
        }
    }()

    // Object type
    public lazy var isClass: Bool = {
        if let clazz = self.classType {
            return true
        }
        return false
    }()
    public lazy var isObject: Bool = {
        if let clazz = self.classType {
            var flag = true
            if let bundleName: String = String(reflecting: Reflector.self).split(".")?.first {
               flag =  NSClassFromString("\(bundleName).\(clazz)") == nil
            }
            
            return (clazz is NSObject.Type) && flag
        }
        return false
    }()
    public lazy var classType: AnyClass? = {
        let type = self.extractType()
        return self.lookupClassType(type)
    }()

    // Collection type
    public lazy var isSet: Bool = {
        if !self.isOptional {
            if let style = self.mirrorType.displayStyle where style == .Set {
                return true
            }
            return false
        }

        let type = self.extractType()
        if type == nsSetName || type == nsMutableSetName || type.hasPrefix(setName) {
            return true
        }
        return false
    }()
    public lazy var isCollection: Bool = {
        if !self.isOptional {
            if let style = self.mirrorType.displayStyle where style == .Collection {
                return true
            }
            return false
        }

        let type = self.extractType()
        if type == nsArrayName || type == nsMutableArrayName || type.hasPrefix(arrayName) {
            return true
        }
        return false
    }()
    public lazy var collectionType: Reflector? = {
        /* Condition validation */
        if !(self.isSet || self.isCollection) {
            return nil
        }
        let type = self.extractType()

        // Validate ObjC type first
        if type == nsArrayName || type == nsMutableArrayName || type == nsSetName || type == nsMutableSetName {
            return Reflector(mirrorName: type, mirrorValue: NSObject())
        }

        let collectionType = self.extractCollectionType(type)
        return self.generateReflector(collectionType)
    }()

    // Dictionary type
    public lazy var isDictionary: Bool = {
        if !self.isOptional {
            if let style = self.mirrorType.displayStyle where style == .Dictionary {
                return true
            }
            return false
        }

        let type = self.extractType()
        if type == nsDictionaryName || type == nsMutableDictionaryName || type.hasPrefix(dictionaryName) {
            return true
        }
        return false
    }()
    public lazy var dictionaryType: (key: Reflector, value: Reflector)? = {
        /* Condition validation */
        if !self.isDictionary {
            return nil
        }
        let type = self.extractType()

        // Validate ObjC type first
        if type == nsDictionaryName || type == nsMutableDictionaryName {
            let key = Reflector(mirrorName: type, mirrorValue: NSObject())
            let value = Reflector(mirrorName: type, mirrorValue: NSObject())

            return (key, value)
        }

        let dictionaryType = self.extractDictionaryType(type)

        guard let value = self.generateReflector(dictionaryType.value) else { return nil }
        guard let key = self.generateReflector(dictionaryType.key) else { return nil }
        return (key, value)
    }()

    private var mirrorName = ""
    private var mirrorType = Mirror(reflecting: Reflector.self)


    // MARK: Class's public methods


    // MARK: Class's private methods
    private func extractCollectionType(type: String) -> String {
        var collectionType = type

        if collectionType.hasPrefix(arrayName) {
            collectionType = collectionType.substring(startIndex: 6, reverseIndex: -1)
        } else if collectionType.hasPrefix(setName) {
            collectionType = collectionType.substring(startIndex: 4, reverseIndex: -1)
        }

        if collectionType.hasPrefix("Optional") {
            collectionType = collectionType.substring(startIndex: 9, reverseIndex: -1)
        }

        return collectionType
    }
    private func extractDictionaryType(type: String) -> (key: String, value: String) {
        var dictionaryType = type

        if dictionaryType.hasPrefix(dictionaryName) {
            dictionaryType = dictionaryType.substring(startIndex: 11, reverseIndex: -1)
        }

        let tokens = dictionaryType.componentsSeparatedByString(", ")
        let key   = tokens[0]
        var value = tokens[1]

        if value.hasPrefix("Optional") {
            value = value.substring(startIndex: 9, reverseIndex: -1)
        }

        return (key, value)
    }
    private func extractType() -> String {
        if !self.isOptional {
            var subjectType = "\(self.mirrorType.subjectType)"

            // Remove ObjC tag
            if subjectType.hasPrefix("__") {
                subjectType = subjectType.substring(startIndex: 2, reverseIndex: -1)
            }

            // Remove Type
            if subjectType.hasSuffix(".Type") {
                subjectType = subjectType.substringToIndex(subjectType.endIndex.advancedBy(-5))
            }

            return subjectType
        } else {
            let subjectType = "\(self.mirrorType.subjectType)"
            let type = subjectType.substring(startIndex: 9, reverseIndex: -1)
            return type
        }
    }

    private func generateReflector(type: String) -> Reflector? {
        if let clazz = self.lookupClassType(type) {
            return Reflector(mirrorName: type, mirrorValue: clazz.self)
        } else if let primitiveType = self.lookupPrimitiveType(type) {
            return Reflector(mirrorName: type, mirrorValue: primitiveType.self)
        }
        return nil
    }

    private func lookupClassType(className: String) -> AnyClass? {
        /* Condition validation */
        if className.characters.count <= 0 {
            return nil
        }

        if let clazz = NSClassFromString(className) {
            return clazz
        } else if let tokens = String(reflecting: Reflector.self).split(".") where tokens.count >= 1 {
            let clazzName = "\(tokens[0]).\(className)"
            return NSClassFromString(clazzName)
        }
        return nil
    }

    public func lookupPrimitiveType(primitiveType: String) -> Any? {
        // Convert from string to Any.Type
        switch primitiveType {

        case "Bool":
            return false

        case "Int":
            return Int(0)
        case "Int8":
            return Int8(0)
        case "Int16":
            return Int16(0)
        case "Int32":
            return Int32(0)
        case "Int64":
            return Int64(0)

        case "UInt":
            return UInt(0)
        case "UInt8":
            return UInt8(0)
        case "UInt16":
            return UInt16(0)
        case "UInt32":
            return UInt32(0)
        case "UInt64":
            return UInt64(0)

        case "Float":
            return Float(0)
        case "Float32":
            return Float32(0)
        case "Float64":
            return Float64(0)
        case "Float80":
            return Float80(0)

        case "Double":
            return Double(0)

        case "Character":
            return Character("a")

        case "String", "NSString", "NSMutableString":
            return ""

        default:
            return nil
        }
    }
}


// Creation
public extension Reflector {


    // MARK: Class's static constructors
    public class func propertiesWithClass(classType: AnyClass) -> [Reflector] {
        return Reflector.propertiesWithClass(classType, baseClass: NSObject.self)
    }
    public class func propertiesWithClass<T: NSObject>(classType: AnyClass, baseClass: T.Type) -> [Reflector] {
        var typeClass: AnyClass = classType
        var properties = [Reflector]()

        while typeClass != T.self {
            /* Condition validation: validate class type */
            guard let aClass = typeClass as? T.Type else {
                break
            }

            // Scan class's properties
            let o = aClass.init()
            let mirror = Mirror(reflecting: o)
            properties = mirror.children.reduce(properties, combine: { (property, child) -> [Reflector] in
                var property = property
                if let label = child.label {
                    let reflector = Reflector(mirrorName: label, mirrorValue: child.value)
                    property.append(reflector)
                }
                return property
            })

            // Lookup super class
            if let parentClass = aClass.superclass() {
                typeClass = parentClass
            } else {
                break
            }
        }
        return properties
    }


    // MARK: Class's constructors
    public convenience init(mirrorName: String, mirrorValue value: Any) {
        self.init()
        self.mirrorName = mirrorName
        self.mirrorType = Mirror(reflecting: value)
    }
}




// Constants
private let arrayName = "Array"
private let nsArrayName = "NSArray"
private let nsMutableArrayName = "NSMutableArray"
private let dictionaryName = "Dictionary"
private let nsDictionaryName = "NSDictionary"
private let nsMutableDictionaryName = "NSMutableDictionary"
private let setName = "Set"
private let nsSetName = "NSSet"
private let nsMutableSetName = "NSMutableSet"
// Mirror types
private let nsStringType = Mirror(reflecting: NSString()).subjectType
private let nsMutablestringType = Mirror(reflecting: NSMutableString()).subjectType
