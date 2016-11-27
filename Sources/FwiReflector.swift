//  Project name: FwiCore
//  File name   : FwiReflector.swift
//
//  Author      : Phuc Tran
//  Created date: 4/27/16
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

import Foundation


public final class FwiReflector: CustomDebugStringConvertible, CustomStringConvertible {

    // MARK: Struct's constructors
    public init(mirrorName name: String = "", mirrorValue value: Any) {
        mirrorName = name
        mirrorType = Mirror(reflecting: value)
    }
    
    // MARK: Struct's properties
    /// Define if a property is optional or not
    public var optionalProperty = false
    /// Return subject's name.
    public fileprivate(set) var mirrorName: String
    /// Return subject's reflector.
    public fileprivate(set) var mirrorType: Mirror
    
    /// Return subject's reflector description.
    public lazy fileprivate(set) var mirrorDescription: String = {
        var string = ""
        
        debugPrint(self.mirrorType.subjectType, to: &string)
        string = string.trim()
        if self.isOptional {
            string = string.substring(startIndex: 15, reverseIndex: -1)
        }
        return string
    }()

    /// Check whether the subject's type is optional type or not.
    public lazy fileprivate(set) var isOptional: Bool = {
        return self.mirrorType.displayStyle == .optional
    }()
    
    /// Check whether the subject's type is enum or not.
    public lazy fileprivate(set) var isEnum: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .enum
        }
        
        // Current implementation does not support optional enum. Thus, always return false
        return false
    }()
    
    /// Check whether the subject's type is tuple or not.
    public lazy fileprivate(set) var isTuple: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .tuple
        }
        
        let end = self.mirrorDescription.length() - 1
        return (self.mirrorDescription[0] == "(" && self.mirrorDescription[end] == ")")
    }()

    /// Check whether the subject's type is struct or not. If subject's type is struct then it
    /// should return the unwrap subject's struct.
    public lazy fileprivate(set) var isStruct: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .`struct`
        }

        let type = self.mirrorType.subjectType
        if type == optionalDataMirror.subjectType || type == optionalDateMirror.subjectType || type == optionalUrlMirror.subjectType {
            return true
        }
        return false
    }()
    public lazy fileprivate(set) var structType: Any.Type? = {
        /* Condition validation */
        if !self.isStruct {
            return nil
        }

        let type = self.mirrorType.subjectType
        if type == dataMirror.subjectType || type == optionalDataMirror.subjectType {
            return dataMirror.subjectType
        }
        else if type == dateMirror.subjectType || type == optionalDateMirror.subjectType {
            return dateMirror.subjectType
        }
        else if type == urlMirror.subjectType || type == optionalUrlMirror.subjectType {
            return urlMirror.subjectType
        }
        return nil
    }()
    
    /// Check whether the subject's type is primitive or not. If subject's type is primitive then
    /// it should return the unwrap subject's type.
    public lazy fileprivate(set) var isPrimitive: Bool = {
        let type = self.mirrorType.subjectType
        
        var isPrimitive = self.isType(type, typeCheck: Bool.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: Int.self)  || self.isType(type, typeCheck: Int8.self)  || self.isType(type, typeCheck: Int16.self)  || self.isType(type, typeCheck: Int32.self)  || self.isType(type, typeCheck: Int64.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: UInt.self) || self.isType(type, typeCheck: UInt8.self) || self.isType(type, typeCheck: UInt16.self) || self.isType(type, typeCheck: UInt32.self) || self.isType(type, typeCheck: UInt64.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: Float.self) || self.isType(type, typeCheck: Float32.self) || self.isType(type, typeCheck: Float64.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: Double.self)
        isPrimitive = isPrimitive || self.isType(type, typeCheck: Character.self) || self.isType(type, typeCheck: String.self)
        
        /* Condition validation: Check special case for NSString or NSMutableString */
        isPrimitive = isPrimitive || (type == objcStringMirror.subjectType)
        isPrimitive = isPrimitive || (type == objcOptionalStringMirror.subjectType)
        isPrimitive = isPrimitive || (type == objcOptionalMutableStringMirror.subjectType)
        
        return isPrimitive
    }()
    public lazy fileprivate(set) var primitiveType: Any.Type? = {
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
    public lazy fileprivate(set) var isClass: Bool = {
        if let clazz = self.classType {
            return true
        }
        return false
    }()
    public lazy fileprivate(set) var isObject: Bool = {
        if let clazz = self.classType, clazz is NSObject.Type {
            return true
        }
        return false
    }()
    public lazy fileprivate(set) var classType: AnyClass? = {
        return FwiReflector.lookup(classType: self.mirrorDescription)
    }()

    /// Check whether the subject's type is collection, set or not. If subject's type is collection
    /// or set then it should return the unwrap collection's type.
    public lazy fileprivate(set) var isSet: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .set
        }

        if self.mirrorType.subjectType == objcOptionalSetMirror.subjectType ||
           self.mirrorType.subjectType == objcOptionalMutableSetMirror.subjectType
        {
            return true
        }
        return self.mirrorDescription.hasPrefix(setName)
    }()
    public lazy fileprivate(set) var isCollection: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .collection
        }

        if self.mirrorType.subjectType == objcOptionalArrayMirror.subjectType ||
           self.mirrorType.subjectType == objcOptionalMutableArrayMirror.subjectType
        {
            return true
        }
        return self.mirrorDescription.hasPrefix(arrayName)
    }()
    public lazy fileprivate(set) var collectionType: FwiReflector? = {
        /* Condition validation */
        if !(self.isSet || self.isCollection) {
            return nil
        }
        
        // Validate ObjC
        if self.mirrorType.subjectType == objcArrayMirror.subjectType ||
           self.mirrorType.subjectType == objcOptionalArrayMirror.subjectType ||
           self.mirrorType.subjectType == objcOptionalMutableArrayMirror.subjectType ||
            
           self.mirrorType.subjectType == objcSetMirror.subjectType ||
           self.mirrorType.subjectType == objcOptionalSetMirror.subjectType ||
           self.mirrorType.subjectType == objcOptionalMutableSetMirror.subjectType
        {
            return FwiReflector(mirrorValue: NSObject())
        }
        
        // Validate Swift
        return self.generateReflector(type: self.extractCollectionType())
    }()
    
    /// Check whether the subject's type is dictionary or not.
    public lazy fileprivate(set) var isDictionary: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .dictionary
        }

        if self.mirrorType.subjectType == objcOptionalDictionaryMirror.subjectType ||
           self.mirrorType.subjectType == objcOptionalMutableDictionaryMirror.subjectType
        {
            return true
        }
        return self.mirrorDescription.hasPrefix(dictionaryName)
    }()
    public lazy fileprivate(set) var dictionaryType: (key: FwiReflector, value: FwiReflector)? = {
        /* Condition validation */
        if !self.isDictionary {
            return nil
        }
        
        
        // Validate ObjC
        let type = self.mirrorType.subjectType
        if type == objcDictionaryMirror.subjectType || type == objcOptionalDictionaryMirror.subjectType || type == objcOptionalMutableDictionaryMirror.subjectType {
            let value = FwiReflector(mirrorValue: NSObject())
            let key = FwiReflector(mirrorValue: NSObject())
            return (key, value)
        }
        
        // Validate Swift
        let dictionaryType = self.extractDictionaryType()
        
        guard let key = self.generateReflector(type: dictionaryType.key), let value = self.generateReflector(type: dictionaryType.value) else {
            return nil
        }
        return (key, value)
    }()
    
    // MARK: Struct's private methods
    /// Create sub reflector. Mainly used for collection type or dictionary type.
    ///
    /// parameter type (required): A string represents for subject's type
    fileprivate func generateReflector(type t: String) -> FwiReflector? {
        if let primitiveType = FwiReflector.lookup(primitiveType: t) {
            return FwiReflector(mirrorValue: primitiveType)
        }
        else if let structType = FwiReflector.lookup(structType: t) {
            return FwiReflector(mirrorValue: structType)
        }
        else if let clazz = FwiReflector.lookup(classType: t) as? NSObject.Type {
            return FwiReflector(mirrorValue: clazz.init())
        }
        else if t == "Any" {
            if (isCollection || isSet) {
                if let collection = mirrorType.children.first?.value as? [Any], collection.count > 0 {
                    return FwiReflector(mirrorValue: collection[0])
                }
            }
            return FwiReflector(mirrorValue: Any.self)
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
    
    /// Extract collection type from mirror's description.
    fileprivate func extractCollectionType() -> String {
        var collectionType = mirrorDescription
        
        if collectionType.hasPrefix(arrayName) {
            collectionType = collectionType.substring(startIndex: 12, reverseIndex: -1)
        }
        else if collectionType.hasPrefix(setName) {
            collectionType = collectionType.substring(startIndex: 10, reverseIndex: -1)
        }
        
        if collectionType.hasPrefix("Swift.Optional") {
            collectionType = collectionType.substring(startIndex: 15, reverseIndex: -1)
        }
        return collectionType
    }
    
    /// Extract dictionary type from mirror's description.
    fileprivate func extractDictionaryType() -> (key: String, value: String) {
        var dictionaryType = mirrorDescription
        
        if dictionaryType.hasPrefix(dictionaryName) {
            dictionaryType = dictionaryType.substring(startIndex: 17, reverseIndex: -1)
        }
        
        let tokens = dictionaryType.components(separatedBy: ", ")
        let key   = tokens[0]
        var value = tokens[1]
        
        if value.hasPrefix("Swift.Optional") {
            value = value.substring(startIndex: 15, reverseIndex: -1)
        }
        return (key, value)
    }
    
    /// Lookup subject's class type.
    ///
    /// parameter className (required): A string represents a class type
    internal static func lookup(classType c: String) -> AnyClass? {
        /* Condition validation */
        if c.length() <= 0 {
            return nil
        }
        
        if let clazz = NSClassFromString(c) {
            return clazz
        }
        else if let name = c.split(".").last, let clazz = NSClassFromString(name) {
            return clazz
        }
        return nil
    }
    
    /// Lookup subject's primitive type.
    ///
    /// parameter primitiveType (required): A string represents a primitive form
    internal static func lookup(primitiveType p: String) -> Any? {
        // Convert from string to Any.Type
        switch p {

        case "Swift.Bool":
            return false

        case "Swift.Int":
            return 0 as Int
        case "Swift.Int8":
            return 0 as Int8
        case "Swift.Int16":
            return 0 as Int16
        case "Swift.Int32":
            return 0 as Int32
        case "Swift.Int64":
            return 0 as Int64

        case "Swift.UInt":
            return 0 as UInt
        case "Swift.UInt8":
            return 0 as UInt8
        case "Swift.UInt16":
            return 0 as UInt16
        case "Swift.UInt32":
            return 0 as UInt32
        case "Swift.UInt64":
            return 0 as UInt64

        case "Swift.Float":
            return 0 as Float
        case "Swift.Float32":
            return 0 as Float32
        case "Swift.Float64":
            return 0 as Float64

        case "Swift.Double":
            return 0 as Double

        case "Swift.Character":
            return " " as Character

        case "Swift.String", "NSString", "NSMutableString":
            return ""

        default:
            return nil
        }
    }
    
    /// Lookup subject's primitive type.
    ///
    /// parameter primitiveType (required): A string represents a primitive form
    internal static func lookup(structType s: String) -> Any? {
        // Convert from string to Any.Type
        switch s {
            
        case "Foundation.Data":
            return Data()
        
        case "Foundation.Date":
            return Date()
            
        case "Foundation.URL":
            return URL(fileURLWithPath: "")
            
        default:
            return nil
        }
    }
    
    // MARK: CustomDebugStringConvertible's members
    public var debugDescription: String {
        return "Reflector for: \(mirrorDescription)"
    }
    
    // MARK: CustomStringConvertible's members
    public var description: String {
        return "Reflector for: \(mirrorDescription)"
    }
}


// Creation
public extension FwiReflector {

    // MARK: Class's static constructors
    /// Return model's property list and its super model. However, the lookup super model process
    /// will stop at the defined base model.
    ///
    /// parameter model (required): any class or struct
    /// parameter baseType (optional): Define base type to stop the lookup super model process
    public static func properties<T: NSObject>(withModel model: T.Type, baseType b: Any.Type = NSObject.self) -> (T?, [FwiReflector]) {
        let o = model.init()
        let properties = FwiReflector.properties(withObject: o)
        
        return (o, properties)
    }
    
    /// Return object's property list and its super model. However, the lookup super model process
    /// will stop at the defined base model.
    ///
    /// parameter object (required): Any instance
    /// parameter baseType (optional): Define base type to stop the lookup super model process
    public static func properties<T: NSObject>(withObject o: T, baseType b: Any.Type = NSObject.self) -> [FwiReflector] {
        return sequence(first: Mirror(reflecting: o),
                        next: {
                            $0.superclassMirror?.subjectType == b ? nil : $0.superclassMirror
                        }).flatMap {
                            $0.children.flatMap({
                                guard let label = $0.label else {
                                    return nil
                                }
                                return FwiReflector(mirrorName: label, mirrorValue: $0.value)
                            })
                        }
    }
}




// Constants
fileprivate let setName = "Swift.Set"
fileprivate let arrayName = "Swift.Array"
fileprivate let dictionaryName = "Swift.Dictionary"
// Mirror types
fileprivate let objcArrayMirror = Mirror(reflecting: NSArray())
fileprivate let objcOptionalArrayMirror = Mirror(reflecting: NSArray() as NSArray? as Any)
fileprivate let objcOptionalMutableArrayMirror = Mirror(reflecting: NSMutableArray() as NSMutableArray? as Any)

fileprivate let objcDictionaryMirror = Mirror(reflecting: NSDictionary())
fileprivate let objcOptionalDictionaryMirror = Mirror(reflecting: NSDictionary() as NSDictionary? as Any)
fileprivate let objcOptionalMutableDictionaryMirror = Mirror(reflecting: NSMutableDictionary() as NSMutableDictionary? as Any)

fileprivate let objcSetMirror = Mirror(reflecting: NSSet())
fileprivate let objcOptionalSetMirror = Mirror(reflecting: NSSet() as NSSet? as Any)
fileprivate let objcOptionalMutableSetMirror = Mirror(reflecting: NSMutableSet() as NSMutableSet? as Any)

fileprivate let objcStringMirror = Mirror(reflecting: NSMutableString())
fileprivate let objcOptionalStringMirror = Mirror(reflecting: NSMutableString() as NSString? as Any)
fileprivate let objcOptionalMutableStringMirror = Mirror(reflecting: NSMutableString() as NSMutableString? as Any)

fileprivate let dataMirror = Mirror(reflecting: Data())
fileprivate let optionalDataMirror = Mirror(reflecting: Data() as Data? as Any)

fileprivate let dateMirror = Mirror(reflecting: Date())
fileprivate let optionalDateMirror = Mirror(reflecting: Date() as Date? as Any)

fileprivate let urlMirror = Mirror(reflecting: URL(fileURLWithPath: ""))
fileprivate let optionalUrlMirror = Mirror(reflecting: URL(fileURLWithPath: "") as URL? as Any)
