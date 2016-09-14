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

    // MARK: Class's constructors
    public init(mirrorName name: String, mirrorValue value: Any) {
        mirrorName = name
        mirrorType = Mirror(reflecting: value)
    }

    // MARK: Class's properties
    /// Define if a property is optional or not
    public var optionalProperty = false
    /// Return subject's name.
    public private (set) var mirrorName: String
    /// Return subject's reflector.
    public private (set) var mirrorType: Mirror

    /// Check whether the subject's type is optional type or not
    public var isOptional: Bool {
        return mirrorType.displayStyle == .optional
    }
    
    /// Check whether the subject's type is enum or not. Currently, this property could not verify
    /// the optional enum.
    public lazy private (set) var isEnum: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .enum
        }
        return false
    }()
    
    /// Check whether the subject's type is tuple or not.
    public lazy private (set) var isTuple: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .tuple
        }

        let type = self.extractType()
        return (type[type.startIndex] == "(" && type[type.characters.index(type.endIndex, offsetBy: -1)] == ")")
    }()
    
    /// Check whether the subject's type is struct or not. If subject's type is struct then it
    /// should return the unwrap subject's struct.
    public lazy private (set) var isStruct: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .`struct`
        }

        let type = self.mirrorType.subjectType
        if type == optionalDataMirror.subjectType || type == optionalDateMirror.subjectType || type == optionalUrlMirror.subjectType {
            return true
        }
        return false
    }()
    public lazy private (set) var structType: Any.Type? = {
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
    public lazy private (set) var isPrimitive: Bool = {
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
    public lazy private (set) var isClass: Bool = {
        if let clazz = self.classType {
            return true
        }
        return false
    }()
    public lazy private (set) var isObject: Bool = {
        // Validate ObjC Collection
        let type = self.mirrorType.subjectType
        if  type == objcArrayMirror.subjectType || type == objcOptionalArrayMirror.subjectType || type == objcOptionalMutableArrayMirror.subjectType ||
            type == objcDictionaryMirror.subjectType || type == objcOptionalDictionaryMirror.subjectType || type == objcOptionalMutableDictionaryMirror.subjectType ||
            type == objcSetMirror.subjectType || type == objcOptionalSetMirror.subjectType || type == objcOptionalMutableSetMirror.subjectType
        {
            return true
        }

        // Validate Swift
        if let clazz = self.classType {
            return (clazz is NSObject.Type)
        }
        return false
    }()
    public lazy private (set) var classType: AnyClass? = {
        let type = self.extractType()
        return self.lookupClass(type)
    }()

    /// Check whether the subject's type is set or not.
    public lazy private (set) var isSet: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .set
        }

        // Validate ObjC
        let type = self.mirrorType.subjectType
        if type == objcOptionalSetMirror.subjectType || type == objcOptionalMutableSetMirror.subjectType {
            return true
        }

        // Validate Swift
        let swiftType = self.extractType()
        return swiftType.hasPrefix(setName)
    }()
    public lazy private (set) var isCollection: Bool = {
        if !self.isOptional {
            return self.mirrorType.displayStyle == .collection
        }

        // Validate ObjC
        let type = self.mirrorType.subjectType
        if type == objcOptionalArrayMirror.subjectType || type == objcOptionalMutableArrayMirror.subjectType {
            return true
        }

        // Validate Swift
        let swiftType = self.extractType()
        return swiftType.hasPrefix(arrayName)
    }()
    public lazy private (set) var collectionType: FwiReflector? = {
        /* Condition validation */
        if !(self.isSet || self.isCollection) {
            return nil
        }

        // Validate ObjC
        let type = self.mirrorType.subjectType
        if type == objcArrayMirror.subjectType || type == objcOptionalArrayMirror.subjectType || type == objcOptionalMutableArrayMirror.subjectType || type == objcOptionalSetMirror.subjectType || type == objcOptionalMutableSetMirror.subjectType {
            return FwiReflector(mirrorName: "", mirrorValue: NSObject())
        }

        // Validate Swift
        let swiftType = self.extractType()
        let collectionType = self.extractCollectionType(swiftType)

        return self.generateReflector(collectionType)
    }()

    // Dictionary type
    public lazy private (set) var isDictionary: Bool = {
        if !self.isOptional {
            if let style = self.mirrorType.displayStyle , style == .dictionary {
                return true
            }
            return false
        }

        // Validate ObjC
        let type = self.mirrorType.subjectType
        if type == objcOptionalDictionaryMirror.subjectType || type == objcOptionalMutableDictionaryMirror.subjectType {
            return true
        }

        // Validate Swift
        let swiftType = self.extractType()
        if swiftType.hasPrefix(dictionaryName) {
            return true
        }
        return false
    }()
    public lazy private (set) var dictionaryType: (key: FwiReflector, value: FwiReflector)? = {
        /* Condition validation */
        if !self.isDictionary {
            return nil
        }

        // Validate ObjC
        let type = self.mirrorType.subjectType
        if type == objcDictionaryMirror.subjectType || type == objcOptionalDictionaryMirror.subjectType || type == objcOptionalMutableDictionaryMirror.subjectType {
            let value = FwiReflector(mirrorName: "", mirrorValue: NSObject())
            let key = FwiReflector(mirrorName: "", mirrorValue: NSObject())
            return (key, value)
        }

        // Validate Swift
        let swiftType = self.extractType()
        let dictionaryType = self.extractDictionaryType(swiftType)

        guard let value = self.generateReflector(dictionaryType.value) else {
            return nil
        }
        guard let key = self.generateReflector(dictionaryType.key) else {
            return nil
        }
        return (key, value)
    }()

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
        } else {
            subjectType = subjectType.substring(startIndex: 9, reverseIndex: -1)
        }
        return subjectType
    }

    fileprivate func generateReflector(_ type: String) -> FwiReflector? {
        if let clazz = self.lookupClass(type), let type = clazz as? NSObject.Type {
            return FwiReflector(mirrorName: "", mirrorValue: type.init())
        }
        else if let primitiveType = self.lookupPrimitive(type) {
            return FwiReflector(mirrorName: "", mirrorValue: primitiveType)
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
            // Try to look for class from current first
            let nameClass = "\(self)"
            if let nameBundle = nameClass.split(".").first, let clazz = NSClassFromString("\(nameBundle).\(className)") {
                return clazz
            }

            // If not good, try to look from all loaded bundle
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
            return 0 as Int
        case "Int8":
            return 0 as Int8
        case "Int16":
            return 0 as Int16
        case "Int32":
            return 0 as Int32
        case "Int64":
            return 0 as Int64

        case "UInt":
            return 0 as UInt
        case "UInt8":
            return 0 as UInt8
        case "UInt16":
            return 0 as UInt16
        case "UInt32":
            return 0 as UInt32
        case "UInt64":
            return 0 as UInt64

        case "Float":
            return 0 as Float
        case "Float32":
            return 0 as Float32
        case "Float64":
            return 0 as Float64

        case "Double":
            return 0 as Double

        case "Character":
            return " " as Character

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
    /// Return model's property list and its super model. However, the lookup super model process
    /// will stop at the defined base model.
    ///
    /// parameter model (required): any class or struct
    /// parameter baseType (optional): Define base type to stop the lookup super model process
    public class func properties<T: NSObject>(withModel model: T.Type, baseType b: Any.Type = NSObject.self) -> (T?, [FwiReflector]) {
        let o = model.init()
        let properties = FwiReflector.properties(withObject: o)
        
        return (o, properties)
    }
    
    /// Return object's property list and its super model. However, the lookup super model process
    /// will stop at the defined base model.
    ///
    /// parameter object (required): Any instance
    /// parameter baseType (optional): Define base type to stop the lookup super model process
    public class func properties<T: NSObject>(withObject o: T, baseType b: Any.Type = NSObject.self) -> [FwiReflector] {
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


// Legacy
public extension FwiReflector {
    
    public var propertyName: String {
        return mirrorName
    }
}




// Constants
fileprivate let setName = "Set"
fileprivate let arrayName = "Array"
fileprivate let dictionaryName = "Dictionary"
// Mirror types
fileprivate let objcArrayMirror = Mirror(reflecting: NSArray())
fileprivate let objcOptionalArrayMirror = Mirror(reflecting: NSArray() as NSArray?)
fileprivate let objcOptionalMutableArrayMirror = Mirror(reflecting: NSMutableArray() as NSMutableArray?)

fileprivate let objcDictionaryMirror = Mirror(reflecting: NSDictionary())
fileprivate let objcOptionalDictionaryMirror = Mirror(reflecting: NSDictionary() as NSDictionary?)
fileprivate let objcOptionalMutableDictionaryMirror = Mirror(reflecting: NSMutableDictionary() as NSMutableDictionary?)

fileprivate let objcSetMirror = Mirror(reflecting: NSSet())
fileprivate let objcOptionalSetMirror = Mirror(reflecting: NSSet() as NSSet?)
fileprivate let objcOptionalMutableSetMirror = Mirror(reflecting: NSMutableSet() as NSMutableSet?)

fileprivate let objcStringMirror = Mirror(reflecting: NSMutableString())
fileprivate let objcOptionalStringMirror = Mirror(reflecting: NSMutableString() as NSString?)
fileprivate let objcOptionalMutableStringMirror = Mirror(reflecting: NSMutableString() as NSMutableString?)

fileprivate let dataMirror = Mirror(reflecting: Data())
fileprivate let optionalDataMirror = Mirror(reflecting: Data() as Data?)

fileprivate let dateMirror = Mirror(reflecting: Date())
fileprivate let optionalDateMirror = Mirror(reflecting: Date() as Date?)

fileprivate let urlMirror = Mirror(reflecting: URL(fileURLWithPath: ""))
fileprivate let optionalUrlMirror = Mirror(reflecting: URL(fileURLWithPath: "") as URL?)
