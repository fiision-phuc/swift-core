//  Project name: FwiCore
//  File name   : FwiJSONMapper.swift
//
//  Author      : Dung Vu
//  Created date: 6/14/16
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


internal struct FwiJSONMapper {

    // MARK: file's properties
    internal static var dateFormat: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return format
    }()
    internal static var numberFormat: NumberFormatter = {
        let format = NumberFormatter()

        format.locale = Locale(identifier: "en_US")
        format.formatterBehavior = .behavior10_4
        format.generatesDecimalNumbers = false
        format.roundingMode = .halfUp
        format.numberStyle = .decimal
        
        return format
    }()

    // MARK: Struct's public methods
    internal static func convert<T: NSObject>(array a: [T]) -> [Any] {
        return a.map { (o) -> [String : Any] in
            return convert(model: o)
        }
    }
    
    /// Convert object to dictionary.
    ///
    /// - parameter object (required): an object to be converted
    internal static func convert<T: NSObject>(model m: T) -> [String : Any] {
        var properties = FwiReflector.properties(withObject: m)
        var d = [String : Any]()
        
        // Remove ignored properties
        if let j = m as? FwiJSONModel {
            properties <- j
        }
        
        // Inject data into object's properties
        for p in properties {
            var value = p.isOptional ? p.mirrorType.children.first?.value : m.value(forKey: p.mirrorName)
            
            if (p.isCollection || p.isSet) {
                if let array = value as? [NSObject], p.collectionType?.isObject == true {
                    value = convert(array: array)
                } else if p.collectionType?.isStruct == true {
                    if let array = value as? [Data] {
                        value = array.reduce([], { (original, data) -> [String] in
                            guard let string = data.encodeBase64String() else {
                                return original
                            }
                            
                            var o = original
                            o.append(string)
                            return o
                        })
                    } else if let array = value as? [Date] {
                        value = array.reduce([], { (original, date) -> [String] in
                            let string = dateFormat.string(from: date)
                            var o = original
                            o.append(string)
                            return o
                        })
                    } else if let array = value as? [URL] {
                        value = array.reduce([], { (original, url) -> [String] in
                            let string = url.absoluteString
                            var o = original
                            o.append(string)
                            return o
                        })
                    }
                }
            } else if p.isDictionary {
                // Should we stop here?
            } else if p.isObject {
                if let o = value as? NSObject {
                    value = convert(model: o)
                }
            } else {
                if p.isStruct {
                    if let d = value as? Data {
                        value = d.encodeBase64String()
                    }
                    else if let d = value as? Date {
                        value = dateFormat.string(from: d)
                    }
                    else if let u = value as? URL {
                        value = u.absoluteString
                    }
                }
            }
            
            /* Condition validation: validate JSON base on https://tools.ietf.org/html/rfc7159#section-2 */
            if value != nil && !(value is NSNumber || value is String || value is [Any] || value is [String : Any]) {
                value = "\(value ?? "")"
            }
            
            // Assign or skip value
            if let v = value {
                d[p.mirrorName] = v
            }
        }
        
        // Convert property to key
        if let j = m as? FwiJSONModel {
            d <- j
        }
        return d
    }
    
    /// Build a list of objects.
    ///
    /// - parameter array (required): a list of keys-values
    /// - parameter model (required): a class which contains a set of properties to be mapped
    @discardableResult
    internal static func map<T: NSObject>(array a: [[String : Any]], toModel m: T.Type) -> ([T]?, NSError?) {
        var userInfo = [String]()
        var array = [T]()
        
        for (idx, d) in a.enumerated() {
            var o = m.init()
            
            guard map(dictionary: d, toObject: &o) == nil else {
                userInfo.append("Could not create 'object' at index: \(idx)")
                continue
            }
            array.append(o)
        }

        // Summary error
        if userInfo.count > 0 {
            return (nil, NSError(domain: "FwiJSONMapper", code: -1, userInfo: ["userInfo":userInfo]))
        }
        return (array, nil)
    }
    
    /// Create instance of a model and map dictionary to that instance.
    ///
    /// - parameter dictionary (required): set of keys-values
    /// - parameter model (required): a class to be initialize for mapping
    internal static func map<T: NSObject>(dictionary d: [String : Any], toModel m: T.Type) -> (T?, NSError?) {
        var o = m.init()
        
        let err = map(dictionary: d, toObject: &o)
        return (o, err)
    }
    
    /// Map dictionary to object.
    ///
    /// - parameter dictionary (required): set of keys-values
    /// - parameter object (required): an object which contains a set of properties to be mapped
    @discardableResult
    internal static func map<T: NSObject>(dictionary d: [String : Any], toObject m: inout T) -> NSError? {
        /* Condition validation: should allow model to perform manual mapping or not */
        if let j = m as? FwiJSONManual {
            let err = j.map(object: d)
            return err as NSError?
        }

        var properties = FwiReflector.properties(withObject: m)
        var userInfo = [String : Any]()
        var dictionary = d

        // Override dictionary if model implement FwiJSONModel
        if let j = m as? FwiJSONModel {
            j <- dictionary
            properties <- j
        }

        // Inject data into object's properties
        var final = [String : Any]()
        for p in properties {
            /* Condition validation: validate JSON base on https://tools.ietf.org/html/rfc7159#section-2 */
            guard let valueJSON = dictionary[p.mirrorName], !(valueJSON is NSNull) || valueJSON is NSNumber || valueJSON is String || valueJSON is [Any] || valueJSON is [String : Any] else {
                if !p.optionalProperty {
                    userInfo[p.mirrorName] = "Could not map 'value' to property: '\(p.mirrorName)' because of incorrect JSON grammar: '\(dictionary[p.mirrorName])'."
                }
                continue
            }

            // Try to convert raw data to right format
            var value = valueJSON
            var canAssign = false
            if let a = value as? [Any], p.isCollection || p.isSet {
                if let collectionType = p.collectionType, let c = collectionType.classType as? NSObject.Type, let objects = a as? [[String : Any]] {
                    let (list, err) = map(array: objects, toModel: c)
                    if let l = list {
                        value = l
                        canAssign = true
                    } else {
                        userInfo[p.mirrorName] = err?.localizedDescription ?? "Could not convert data into array."
                    }
                } else {
                    if let array = a + p {
                        value = array
                        canAssign = true
                    }
                }
            } else if let d = value as? [String : Any], p.isDictionary || p.isObject {
                if p.isObject {
                    if let c = p.classType as? NSObject.Type {
                        let (child, err) = map(dictionary: d, toModel: c)
                        if let c = child {
                            value = c
                            canAssign = true
                        } else {
                            dictionary[p.mirrorName] = err?.localizedDescription ?? "Could not convert data into object."
                        }
                    }
                } else {
                    if let objects = d + p {
                        value = objects
                        canAssign = true
                    }
                }
            } else {
                if let s = value as? String {
                    if let v = s + p {
                        value = v
                        canAssign = true
                    }
                } else if let n = value as? NSNumber, p.isStruct && p.structType == Date.self {
                    if let d = transformDate(n) {
                        value = d
                        canAssign = true
                    }
                } else {
                    if p.primitiveType == String.self {
                        value = "\(value)"
                    }
                    canAssign = true
                }
            }
            
            // Assign value to property if can
            if canAssign && m.responds(to: NSSelectorFromString(p.mirrorName)) == true {
                final[p.mirrorName] = value
            } else {
                if !p.optionalProperty {
                    userInfo[p.mirrorName] = "could not map '\(value)' to this property due to data's type conflict."
                }
            }
        }
        
        // Summary error
        if userInfo.keys.count > 0 {
            var message = "There is an error when trying to map data into model: \(NSStringFromClass(type(of: m)))\n"
            userInfo.forEach({
                message += "-> [\($0)] \($1)\n"
            })
            FwiLog(message)
            
            return NSError(domain: "FwiJSONMapper", code: -1, userInfo: [NSLocalizedDescriptionKey:message])
        }
        
        m.setValuesForKeys(final)
        return nil
    }

    // MARK: Struct's private methods
    /// Transform JSON date to date object.
    ///
    /// parameter value (required): JSON date, can be either in string form or number form
    /// parameter format (optional): format string to convert string to date
    internal static func transformDate(_ value: Any?, formats: [String] = ["yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HHmmss'GMT'"]) -> Date? {
        if let number = value as? TimeInterval {
            return Date(timeIntervalSince1970: number)
        } else if let number = value as? NSNumber {
            return Date(timeIntervalSince1970: number.doubleValue)
        }

        if let dateString = value as? String {
            if dateString.matchPattern("^\\d+$") {
                if let number = FwiJSONMapper.numberFormat.number(from: dateString) as? TimeInterval {
                    return Date(timeIntervalSince1970: number)
                }
            }
            else {
                let dateFormatter = DateFormatter()
                for format in formats {
                    dateFormatter.dateFormat = format
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    }
                }
            }
        }
        return nil
    }
}


// MARK: Custom Operator
infix operator <-

/// Transform array.
///
/// parameter left (required): an original data in string form
/// parameter right (required): a property description from model
fileprivate func + (left: [Any], right: FwiReflector) -> [Any]? {
    if let _ = left as? [NSNumber], let collectionType = right.collectionType, collectionType.primitiveType != String.self {
        return left
    }
    else if let a = left as? [String], let collectionType = right.collectionType {
        if collectionType.mirrorType.subjectType == anyMirror.subjectType || (collectionType.isPrimitive && collectionType.primitiveType == String.self) {
            return a
        }
        else {
            return a.map { ($0 + collectionType ?? NSNull()) }
                    .filter { !($0 is NSNull) }
        }
    }
    return nil
}

/// Transform dictionary.
///
/// parameter left (required): an original data in string form
/// parameter right (required): a property description from model
fileprivate func + (left: [String : Any], right: FwiReflector) -> [String : Any]? {
    guard let dictionaryType = right.dictionaryType else {
        return nil
    }
    let validKey = (dictionaryType.key.primitiveType == String.self)
    
    if let _ = left as? [String:NSNumber], validKey && dictionaryType.value.primitiveType != String.self {
        return left
    }
    else if let l = left as? [String:String], validKey {
        if dictionaryType.value.mirrorType.subjectType == anyMirror.subjectType || (dictionaryType.value.isPrimitive && dictionaryType.value.primitiveType == String.self) {
            return left
        }
        else {
            var dictionary = [String : Any]()
            
            l.forEach({
                if let v = $1 + dictionaryType.value {
                    dictionary[$0] = v
                }
            })
            return dictionary.count > 0 ? dictionary : nil
        }
    }
    return nil
}

/// Transform string.
///
/// parameter left (required): an original data in string form
/// parameter right (required): a property description from model
fileprivate func + (left: String, right: FwiReflector) -> Any? {
    if let primitiveType = right.primitiveType {
        if primitiveType != String.self {
            return FwiJSONMapper.numberFormat.number(from: left.trim())
        } else {
            return left
        }
    }
    else if let structType = right.structType {
        if structType == Data.self {
            return left.decodeBase64Data() ?? left.toData()
        }
        else if structType == Date.self {
            return FwiJSONMapper.transformDate(left)
        }
        else if structType == URL.self {
            return URL(string: left.encodeHTML())
        }
    }
    return nil
}

/// Update input property list before mapping process occur.
///
/// parameter left (required): a property list
/// parameter right (required): an instance of model that implemented FwiJSONModel
fileprivate func <- (left: inout [FwiReflector], right: FwiJSONModel) {
    if let ignoreProperties = right.ignoreProperties {
        left = left.filter({ ignoreProperties.contains($0.mirrorName) == false })
    }

    left.forEach({
        if right.optionalProperties?.contains($0.mirrorName) == true {
            $0.optionalProperty = true
        }
    })
}

/// Update output dictionary after mapping process occured.
///
/// parameter left (required): an instance of model that implemented FwiJSONModel
/// parameter right (required): a dictionary that will be update
fileprivate func <- (left: inout [String : Any], right: FwiJSONModel) {
    right.keyMapper?.forEach({
        left[$0.key] = left[$0.value]
        left.removeValue(forKey: $0.value)
    })
}

/// Update input dictionary before mapping process occur.
///
/// parameter left (required): a dictionary that will be update
/// parameter right (required): an instance of model that implemented FwiJSONModel
fileprivate func <- (left: FwiJSONModel, right: inout [String : Any]) {
    right = left.convertJSON(fromOriginal: right)
    left.keyMapper?
        .filter({ (item) -> Bool in
            return (item.key != item.value)
        })
        .forEach({
            right[$0.value] = right[$0.key]
            right.removeValue(forKey: $0.key)
        })
}

// Mirror types
fileprivate let anyMirror = Mirror(reflecting: Any.self)
