//  Project name: FwiCore
//  File name   : FwiReflector.swift
//
//  Author      : Phuc Tran
//  Created date: 4/27/16
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

import Foundation


public final class FwiReflector {

    /// MARK: Class's constructors
    public init(mirrorName name: String, mirrorValue value: Any) {
        mirrorName = name
        mirrorType = Mirror(reflecting: value)
        
    }

    /// MARK: Class's properties
    public private (set) var mirrorName: String
    public private (set) var mirrorType: Mirror
    
    /// Check whether the subject's type is optional type or not
    public lazy private (set) var isOptional: Bool = {
        return self.mirrorType.displayStyle == .optional
    }()
    
    /// Check whether the subject's type is enum or not. Currently, this property could not verify
    /// the optional enum.
    public lazy var isEnum: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .enum
        } else {
            return false
        }
    }()
    
    /// Check whether the subject's type is tuple or not.
    public lazy private (set) var isTuple: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .tuple
        }

        let type = self.extractType()
        return (type[type.startIndex] == "(" && type[type.characters.index(type.endIndex, offsetBy: -1)] == ")")
    }()
    
    /// Check whether the subject's type is struct or not.
    public lazy private (set) var isStruct: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .`struct`
            /*
            if let style = self.mirrorType.displayStyle, style == .`struct` {
                let nTest: String = "\(self.mirrorType.subjectType)"
                let result: (Bool, Bool) = (nTest == "URL", nTest == "Date")
                switch result {
                case (true, false):
                    self.structType = URL.self
                    return true
                case (false, true):
                    self.structType = Date.self
                    return true
                default:
                    return true
                }
            }
            return false
            */
        }
        
        let m = self.mirrorType.displayStyle
        let nTest: String = "\(self.mirrorType.subjectType)"
        let result: (Bool, Bool) = (nTest.contains("<URL>"), nTest.contains("<Date>"))
        switch result {
        case (true, false):
            self.structType = URL.self
            return true
        case (false, true):
            self.structType = Date.self
            return true
        default:
            return false
        }
    }()
    
    public private (set) var structType: Any.Type = String.self
    
    /// Check whether the subject's type is primitive or not. If subject's type is primitive then
    /// it should return the unwrap subject's type.
    public lazy private (set) var isPrimitive: Bool = {
        let type = self.mirrorType.subjectType
        
        var isPrimitive = self.isType(type, typeCheck: Bool.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: Int.self)  || self.isType(type, typeCheck: Int8.self)  || self.isType(type, typeCheck: Int16.self)  || self.isType(type, typeCheck: Int32.self)  || self.isType(type, typeCheck: Int64.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: UInt.self) || self.isType(type, typeCheck: UInt8.self) || self.isType(type, typeCheck: UInt16.self) || self.isType(type, typeCheck: UInt32.self) || self.isType(type, typeCheck: UInt64.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: Float.self) || self.isType(type, typeCheck: Float32.self) || self.isType(type, typeCheck: Float64.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: Double.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: Character.self) || self.isType(type, typeCheck: String.self)
        
        return isPrimitive
    }()
    public lazy private (set) var primitiveType: Any.Type? = {
        /* Condition validation */
        if !self.isPrimitive {
            return nil
        }
        let type = self.mirrorType.subjectType
        
        if self.isType(type, typeCheck: Bool.self) {
            return Bool.self
        } else if self.isType(type, typeCheck: Int.self) {
            return Int.self
        } else if self.isType(type, typeCheck: Int8.self) {
            return Int8.self
        } else if self.isType(type, typeCheck: Int16.self) {
            return Int16.self
        } else if self.isType(type, typeCheck: Int32.self) {
            return Int32.self
        } else if self.isType(type, typeCheck: Int64.self) {
            return Int64.self
        } else if self.isType(type, typeCheck: UInt.self) {
            return UInt.self
        } else if self.isType(type, typeCheck: UInt8.self) {
            return UInt8.self
        } else if self.isType(type, typeCheck: UInt16.self) {
            return UInt16.self
        } else if self.isType(type, typeCheck: UInt32.self) {
            return UInt32.self
        } else if self.isType(type, typeCheck: UInt64.self) {
            return UInt64.self
        } else if self.isType(type, typeCheck: Float.self) {
            return Float.self
        } else if self.isType(type, typeCheck: Float32.self) {
            return Float32.self
        } else if self.isType(type, typeCheck: Float64.self) {
            return Float64.self
        } else if self.isType(type, typeCheck: Double.self) {
            return Double.self
        } else if self.isType(type, typeCheck: Character.self) {
            return Character.self
        } else {
            return String.self
        }
    }()

    /// Check whether the subject's type is class or not, can be ObjC's class or Swift's class. If
    /// subject's type is class then it should return the unwrap subject's class.
    public lazy var isClass: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .class
        }

        if let clazz = self.classType {
            return true
        }
        return false
    }()
    public lazy var isObject: Bool = {  /// Check whether the subject's type is ObjC's class or not.
        if let clazz = self.classType {
            return (clazz is NSObject.Type)
        }
        return false
    }()
    public lazy var classType: AnyClass? = {
        let type = self.extractType()
        return self.lookupClass(type)
    }()

    /// Check whether the subject's type is set or not.
    public lazy var isSet: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .set
        }

        let type = self.extractType()
        if type == nsSetName || type == nsMutableSetName || type.hasPrefix(setName) {
            return true
        }
        return false
    }()
    public lazy var isCollection: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .collection
        }

        let type = self.extractType()
        if type == nsArrayName || type == nsMutableArrayName || type.hasPrefix(arrayName) {
            return true
        }
        return false
    }()
    public lazy var collectionType: FwiReflector? = {
        /* Condition validation */
        if !(self.isSet || self.isCollection) {
            return nil
        }
        let type = self.extractType()

        // Validate ObjC type first
        if type == nsArrayName || type == nsMutableArrayName || type == nsSetName || type == nsMutableSetName {
            return FwiReflector(mirrorName: type, mirrorValue: NSObject())
        }

        let collectionType = self.extractCollectionType(type)
        return self.generateReflector(collectionType)
    }()

    // Dictionary type
    public lazy var isDictionary: Bool = {
        if !self.isOptional {
            if let style = self.mirrorType.displayStyle , style == .dictionary {
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
    public lazy var dictionaryType: (key: FwiReflector, value: FwiReflector)? = {
        /* Condition validation */
        if !self.isDictionary {
            return nil
        }
        let type = self.extractType()

        // Validate ObjC type first
        if type == nsDictionaryName || type == nsMutableDictionaryName {
            let key = FwiReflector(mirrorName: type, mirrorValue: NSObject())
            let value = FwiReflector(mirrorName: type, mirrorValue: NSObject())

            return (key, value)
        }

        let dictionaryType = self.extractDictionaryType(type)

        guard let value = self.generateReflector(dictionaryType.value) else { return nil }
        guard let key = self.generateReflector(dictionaryType.key) else { return nil }
        return (key, value)
    }()

    // MARK: Class's public methods

    // MARK: Class's private methods
    fileprivate func extractCollectionType(_ type: String) -> String {
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
    fileprivate func extractDictionaryType(_ type: String) -> (key: String, value: String) {
        var dictionaryType = type

        if dictionaryType.hasPrefix(dictionaryName) {
            dictionaryType = dictionaryType.substring(startIndex: 11, reverseIndex: -1)
        }

        let tokens = dictionaryType.components(separatedBy: ", ")
        let key   = tokens[0]
        var value = tokens[1]

        if value.hasPrefix("Optional") {
            value = value.substring(startIndex: 9, reverseIndex: -1)
        }

        return (key, value)
    }
    
    /// Extract type from optional string description. Currently, there is no other available method
    /// to find subject's type from optional.
    fileprivate func extractType() -> String {
        var subjectType = "\(self.mirrorType.subjectType)"
        
        if !self.isOptional {
            // Remove ObjC tag
            if subjectType.hasPrefix("__") {
                subjectType = subjectType.substring(startIndex: 2, reverseIndex: -1)
            }

            // Remove Type
            if subjectType.hasSuffix(".Type") {
                subjectType = subjectType.substring(to: subjectType.index(subjectType.endIndex, offsetBy: -5))
            }
        } else {
            subjectType = subjectType.substring(startIndex: 9, reverseIndex: -1)
        }
        return subjectType
    }

    fileprivate func generateReflector(_ type: String) -> FwiReflector? {
        if let clazz = self.lookupClass(type) {
            return FwiReflector(mirrorName: type, mirrorValue: clazz)
        } else if let primitiveType = self.lookupPrimitive(type) {
            return FwiReflector(mirrorName: type, mirrorValue: primitiveType)
        }
        return nil
    }
    
    /// Validate if subject's type is right type that we are looking for, either optional or non
    /// optional.
    fileprivate func isType<T>(_ type: Any.Type, typeCheck check: T.Type) -> Bool {
        if type == T.self || type == Optional<T>.self {
            return true
        }
        return false
    }
    
    /// Lookup subject's class from all loaded bundle. Currently there is no other way to detect if
    /// class's name belong to which bundle.
    fileprivate func lookupClass(_ className: String) -> AnyClass? {
        /* Condition validation */
        if className.characters.count <= 0 {
            return nil
        }
        
        if let clazz = NSClassFromString(className) {
            return clazz
        } else {
            for bundle in Bundle.allBundles {
                if let module = bundle.bundleIdentifier?.split(".").last, bundle.load() {
                    if let clazz = NSClassFromString("\(module).\(className)") {
                        return clazz
                    }
                }
            }
        }
        return nil
    }

    public func lookupPrimitive(_ primitiveType: String) -> Any? {
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
public extension FwiReflector {

    // MARK: Class's static constructors
    public class func propertiesWithClass(_ classType: AnyClass) -> [FwiReflector] {
        return FwiReflector.propertiesWithClass(classType, baseClass: NSObject.self)
    }
    public class func propertiesWithClass<T: NSObject>(_ classType: AnyClass, baseClass: T.Type) -> [FwiReflector] {
        var typeClass: AnyClass = classType
        var properties = [FwiReflector]()

        while typeClass != T.self {
            /* Condition validation: validate class type */
            guard let aClass = typeClass as? T.Type else {
                break
            }

            // Scan class's properties
            let o = aClass.init()
            let mirror = Mirror(reflecting: o)
            properties = mirror.children.reduce(properties, { (property, child) -> [FwiReflector] in
                var property = property
                if let label = child.label {
                    let reflector = FwiReflector(mirrorName: label, mirrorValue: child.value)
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
}


// Legacy
public extension FwiReflector {
    
    public var propertyName: String {
        return mirrorName
    }
}




// Constants
fileprivate let arrayName = "Array"
fileprivate let nsArrayName = "NSArray"
fileprivate let nsMutableArrayName = "NSMutableArray"
fileprivate let dictionaryName = "Dictionary"
fileprivate let nsDictionaryName = "NSDictionary"
fileprivate let nsMutableDictionaryName = "NSMutableDictionary"
fileprivate let setName = "Set"
fileprivate let nsSetName = "NSSet"
fileprivate let nsMutableSetName = "NSMutableSet"
// Mirror types
fileprivate let nsStringType = Mirror(reflecting: NSString()).subjectType
fileprivate let nsMutablestringType = Mirror(reflecting: NSMutableString()).subjectType
