//  Project name: FwiCore
//  File name   : FwiJSONMapper.swift
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

import UIKit
import Foundation


public struct FwiJSONMapper {

    // MARK: Class's public methods
    /// Build a list of objects.
    ///
    /// - parameter array (required): a list of keys-values
    /// - parameter model (required): a class which contains a set of properties to be mapped
    @discardableResult
    public static func map<T: NSObject>(array a: [[String : Any]], toModel m: T.Type) -> ([T], NSError?) {
            var array = [T]()
            for d in a {
                var o = m.init()
                
                guard map(dictionary: d, toObject: &o) == nil else {
//                    userInfo[p.mirrorName] = "\(p.mirrorName) has invalid data."
                    continue
                }
                array.append(o)
            }
        return (array, nil)
    }
    
    /// Create instance of a model and map dictionary to that instance.
    ///
    /// - parameter dictionary (required): set of keys-values
    /// - parameter model (required): a class to be initialize for mapping
    public static func map<T: NSObject>(dictionary d: [String : Any], toModel m: T) -> (T?, NSError?) {
        return (nil, nil)
    }
    
    /// Map dictionary to object.
    ///
    /// - parameter dictionary (required): set of keys-values
    /// - parameter object (required): an object which contains a set of properties to be mapped
    @discardableResult
    public static func map<T: NSObject>(dictionary d: [String : Any], toObject m: inout T) -> NSError? {
        var properties = FwiReflector.properties(withObject: m)
        var errorInfo = [String : Any]()
        var dictionary = d

        // Override dictionary if model implement FwiJSONModel
        if let j = m as? FwiJSONModel {
            j.keyMapper?.forEach({
                dictionary[$1] = dictionary[$0]
                dictionary.removeValue(forKey: $0)
            })
            
            if let ignoreProperties = j.ignoreProperties {
                properties = properties.filter({ ignoreProperties.contains($0.mirrorName) == false })
            }
 
            properties.forEach({
                if j.optionalProperties?.contains($0.mirrorName) == true {
                    $0.optionalProperty = true
                }
            })
        }

        // Inject data into object's properties
        for p in properties {
            /* Condition validation: validate json type */
            guard let valueJSON = dictionary[p.mirrorName], valueJSON is NSNull || valueJSON is NSNumber || valueJSON is String || valueJSON is [Any] || valueJSON is [String : Any] else {
                errorInfo[p.mirrorName] = "Could not map 'value' to property: '\(p.mirrorName)' because of incorrect JSON grammar: '\(dictionary[p.mirrorName])'"
                continue
            }

            /* Condition validation: validate optional property */
            if !p.optionalProperty && valueJSON is NSNull {
                errorInfo[p.mirrorName] = "\(p.mirrorName) is missing."
                continue
            }

            // Try to convert raw data to right format
            var value = valueJSON
            var canAssign = false
            if let a = value as? [Any], p.isCollection || p.isSet {
                if let objects = a as? [[String : Any]], let collectionType = p.collectionType, let c = collectionType.classType as? NSObject.Type {
                    let (list, err) = map(array: objects, toModel: c)
                    if err != nil {
                        FwiLog("\(err)")
                    }
                    else {
                        value = list
                        canAssign = true
                    }
                } else {
                    canAssign = true
                }
            }
            else if let d = value as? [String : Any], p.isDictionary || p.isObject {
                if p.isObject {
                    if let c = p.classType as? NSObject.Type {
                        var child = c.init()
                        
                        if let err = map(dictionary: d, toObject: &child) {
                            FwiLog("\(err)")
                        } else {
                            value = child
                            canAssign = true
                        }
                    }
                }
                else {
                    let validKey = (p.dictionaryType?.key.primitiveType == String.self)
                    
                    if let _ = d as? [String:NSNumber], p.dictionaryType?.value.primitiveType != String.self {
                        canAssign = (validKey && true)
                    } else if let _ = d as? [String:String], p.dictionaryType?.value.primitiveType == String.self {
                        canAssign = (validKey && true)
                    }
                }
            }
            else {
                if let primitiveType = p.primitiveType {
                    if let string = value as? String, primitiveType != String.self {
                        if let number = numberFormat.number(from: string.trim()) {
                            value = number
                            canAssign = true
                        }
                    } else {
                        canAssign = true
                    }
                }
                else if let structType = p.structType {
                    if structType == Data.self {
                        if let string = value as? String, let data = string.decodeBase64Data() {
                            value = data
                            canAssign = true
                        } else if let string = value as? String, let data = string.toData() {
                            value = data
                            canAssign = true
                        }
                    } else if structType == Date.self {
                        if let date = self.transformDate(value) {
                            value = date
                            canAssign = true
                        }
                    } else if structType == URL.self {
                        if let string = value as? String, let url = URL(string: string.encodeHTML()) {
                            value = url
                            canAssign = true
                        }
                    }
                }
            }
            
            // Assign value to property if can
            if canAssign && m.responds(to: NSSelectorFromString(p.mirrorName)) == true {
                m.setValue(value, forKey: p.mirrorName)
            } else {
                errorInfo[p.mirrorName] = "could not map '\(value)' to this property due to data's type conflict."
            }
        }
        
//        if errorUserInfo.keys.count > 0 {
//            return NSError(domain: NSURLErrorKey, code: NSURLErrorUnknown, userInfo: errorUserInfo)
//        }
        return nil
    }

    // MARK: Class's private methods
    fileprivate static var numberFormat: NumberFormatter = {
        let numberFormat = NumberFormatter()

        numberFormat.locale = Locale(identifier: "en_US")
        numberFormat.formatterBehavior = .behavior10_4
        numberFormat.generatesDecimalNumbers = true
        numberFormat.roundingMode = .halfUp
        numberFormat.numberStyle = .decimal

        return numberFormat
    }()

    /// Transform JSON date to date object.
    ///
    /// parameter value (required): JSON date, can be either in string form or number form
    /// parameter format (optional): format string to convert string to date
    fileprivate static func transformDate(_ value: Any?, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
        if let number = value as? NSNumber {
            return Date(timeIntervalSince1970: number.doubleValue)
        }

        if let dateString = value as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format

            return dateFormatter.date(from: dateString)
        }

        return nil
    }
}

// Creation
public extension FwiJSONMapper {

    // MARK: Class's static constructors
    public static func mapObjectToModel<T: NSObject>(_ object: Any?, model m: inout T) -> NSError? {
        if let dictionary = object as? [String: AnyObject] {
            return FwiJSONMapper.mapDictionaryToModel(dictionary, model: &m)
        }

        return NSError(domain: NSURLErrorKey, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: "Parse object to dictionary error !!!"])
    }

    public static func toDictionary<T: NSObject>(_ object: T) -> [String: Any] {
        var result: [String: Any] = [:]

        // Create Mirror Value Follow Properties
        let mirror = Mirror(reflecting: object)

        // Reflector Object To Identify Type Properties
        let reflectorItems = FwiReflector.properties(withObject: object)
        
        // Create dictionary from object
        var dictionaryKey: [String: String] = [:]
        dictionaryKey = mirror.children.reduce(dictionaryKey, { (temp, child) -> [String: String] in
            var temp = temp

            if let label = child.label {
                temp[label] = label
            }
            return temp
        })

        // Tracking if it has swap key
        if let jsonModel = object as? FwiJSONModel {
            // Check It Has KeyMapper
            if let keyMapper = jsonModel.keyMapper {
                // Swap Key
                for (key, value) in keyMapper {
                    if dictionaryKey[value] != nil {
                        dictionaryKey.removeValue(forKey: value)
                        dictionaryKey[key] = value
                    }
                }
            }
        }

        // Loop in Dictionary Key To Find Result
        for (keyJson, nameProperty) in dictionaryKey {
            // Find Value Of Properties
            let value = mirror.children.first(where: {$0.label == nameProperty})?.value

            // Find Reflector of property
            guard let reflector = reflectorItems.first(where: { $0.propertyName == nameProperty }) else {
//                // nil , it can't identify
                continue
            }

            // if it is primity type
            if reflector.isPrimitive {
                result[keyJson] = value
            } else {
                // Object
                if reflector.isObject {
                    // NSURL
                    if let url = value as? URL {
                        // Return a absolute string of url
                        result[keyJson] = url.absoluteString
                    }
                    // NSDate
                    else if let date = value as? Date {
                        // Return a double value
                        result[keyJson] = date.timeIntervalSince1970
                    }
                    // Try other
                    else if let obj = value {
                        result[keyJson] = obj
                    }
                }
                // Class
                else if reflector.isClass {
                    //
                    if let obj = value as? NSObject {
                        // Tracking If Object has Init Function
                        if obj.responds(to: #selector(type(of: obj).init)) {
                            let newDict = FwiJSONMapper.toDictionary(obj)
                            result[keyJson] = newDict
                        }
                    }
                }
                // Dictionary
                else if reflector.isDictionary {
                    // Create a dictionay temp
                    var temp: [String: Any] = [:]

                    defer {
                        if temp.keys.count > 0 {
                            result[keyJson] = temp
                        }
                    }

                    // Cast to choice dictionary type
                    if let newDict = value as? [String: AnyObject] {
                        // Loop in new dict to find value
                        for (key, newValue) in newDict {
                            // Check Value type
                            let reflectItem = FwiReflector(mirrorName: key, mirrorValue: newValue)
                            if reflectItem.isPrimitive || newValue is String || newValue is NSNumber {
                                temp[key] = newValue
                            } else {
                                // Other
                                if let objDict = newValue as? NSObject {
                                    // Tracking If Object has Init Function
                                    if objDict.responds(to: #selector(type(of: objDict).init)) {
                                        let dictObj = FwiJSONMapper.toDictionary(objDict)
                                        temp[key] = dictObj
                                    }
                                }
                            }
                        }
                    }
                    // Try to NSDictionary
                    else if let newDict = value as? NSDictionary {
                        // Loop in new dict to find value
                        for (key, newValue) in newDict {
                            if let keyPath = key as? String {
                                // Loop in new dict to find value
                                // Check Value type
                                let reflectItem = FwiReflector(mirrorName: keyPath, mirrorValue: newValue)
                                if reflectItem.isPrimitive || newValue is String || newValue is NSNumber {
                                    temp[keyPath] = newValue
                                } else {
                                    // Other
                                    if let objDict = newValue as? NSObject {
                                        // Tracking If Object has Init Function
                                        if objDict.responds(to: #selector(type(of: objDict).init)) {
                                            let dictObj = FwiJSONMapper.toDictionary(objDict)
                                            temp[keyPath] = dictObj
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                // Collection
                else if reflector.isCollection {
                    // Create Array temp
                    var temp: [AnyObject] = []
                    defer {
                        if temp.count > 0 {
                            result[keyJson] = temp
                        }
                    }

                    if let arrItem = value as? NSArray {
                        for valueItem in arrItem {
                            let reflect = FwiReflector(mirrorName: "", mirrorValue: valueItem)
                            if reflect.isPrimitive || valueItem is String || valueItem is NSNumber {
                                temp.append(valueItem as AnyObject)
                            } else {
                                if let newItem = valueItem as? NSObject {
                                    // Tracking If Object has Init Function
                                    if newItem.responds(to: #selector(type(of: newItem).init)) {
                                        let newDict = FwiJSONMapper.toDictionary(newItem)
                                        temp.append(newDict as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return result
    }

    // MARK: Class's constructors
}

// Legacy
public extension FwiJSONMapper {
    
    /** Map Dictionary To Model. */
    public static func mapDictionaryToModel<T: NSObject>(_ dictionary: [String: AnyObject], model m: inout T) -> NSError? {
        var dictionary =  (m as? FwiJSONModel)?.convertJSON(fromOriginal: dictionary) ?? dictionary
        let optionalProperties = (m as? FwiJSONModel)?.optionalProperties ?? []
        var (_, properties) = FwiReflector.properties(withModel: type(of: m))
        var errorUserInfo: [String: Any] = [:]
        
        // Override dictionary if neccessary
        if let json = m as? FwiJSONModel {
            if let keyMapper = json.keyMapper {
                for (k, v) in keyMapper {
                    dictionary[v] = dictionary[k]
                    dictionary.removeValue(forKey: k)
                }
            }
            
            // Filter Ignore property
            if let optionalProperties = json.optionalProperties {
                properties.forEach({
                    if optionalProperties.contains($0.mirrorName) {
                        $0.optionalProperty = true
                    }
                })
            }
        }
        
        // Map values to properties
        for p in properties {
            // Find Value In Json
            let valueJson = dictionary[p.propertyName]
            
            // Check property is optional
            let isOptional = optionalProperties.contains(p.propertyName)
            
            /* Condition validation: Validate nullable value */
            if valueJson == nil || valueJson is NSNull {
                if !isOptional { errorUserInfo[p.propertyName] = "Not Find Value For Key" }
                continue
            }
            
            // Check primitiveType first , because it's basic and easy
            if p.isPrimitive {
                // Find Type Primitive
                if let primitiveType = p.primitiveType {
                    var value = p.lookupPrimitive("\(primitiveType)")
                    
                    // Convert value first
                    value <- (valueJson as AnyObject?)
                    
                    // Check value nil and not optional
                    if value == nil && isOptional == false {
                        errorUserInfo[p.propertyName] = "Not Find Value For Key"
                    } else {
                        
                        // Check exsist set key value
                        if m.responds(to: NSSelectorFromString(p.propertyName)) {
                            m.setValue(value, forKey: p.propertyName)
                        } else {
                            fatalError("Not Support Property Optional Bool, Int , Double!!!! , Try to don't using Optional")
                        }
                    }
                } else {
                    errorUserInfo[p.propertyName] = "Not found type for key"
                }
                
            } else {
                // Check Other Type
                if p.isStruct {
                    // only date , url other not recognize
                    
                    if p.structType == URL.self {
                        var value: URL?
                        if let path = valueJson as? String {
                            // Valid URL
                            let validUrl = path.encodeHTML()
                            value = URL(string: validUrl)
                        }
                        
                        if value == nil && isOptional == false {
                            errorUserInfo[p.propertyName] = "Not Find Value For Key"
                        } else {
                            m.setValue(value, forKey: p.propertyName)
                        }
                    }
                        // NSDate
                    else if p.structType == Date.self {
                        var value: Date?
                        
                        value = transformDate(valueJson)
                        
                        if value == nil && isOptional == false {
                            errorUserInfo[p.propertyName] = "Not Find Value For Key"
                        } else {
                            m.setValue(value, forKey: p.propertyName)
                        }
                    }else {
                        fatalError("Not support , only url and date")
                    }
                    
                }
                    /* Object */
                else if p.isObject {
                    // NSURL
                    if p.classType == NSURL.self || p.classType == NSURL?.self {
                        var value: NSURL?
                        if let path = valueJson as? String {
                            // Valid URL
                            let validUrl = path.encodeHTML()
                            value = NSURL(string: validUrl)
                        }
                        
                        if value == nil && isOptional == false {
                            errorUserInfo[p.propertyName] = "Not Find Value For Key"
                        } else {
                            m.setValue(value, forKey: p.propertyName)
                        }
                    }
                        // NSDate
                    else if p.classType == NSDate.self || p.classType == NSDate?.self {
                        var value: NSDate?
                        
                        value = transformDate(valueJson) as NSDate?
                        
                        if value == nil && isOptional == false {
                            errorUserInfo[p.propertyName] = "Not Find Value For Key"
                        } else {
                            m.setValue(value, forKey: p.propertyName)
                        }
                    }
                        // Try Other
                    else {
                        var value: AnyObject?
                        if let classaz = p.classType as? NSObject.Type {
                            var obj = classaz.init()
                            obj <- (valueJson as AnyObject?)
                            value = obj
                            
                            
                            if value == nil && isOptional == false {
                                errorUserInfo[p.propertyName] = "Not Find Value For Key"
                            } else {
                                m.setValue(value, forKey: p.propertyName)
                            }
                        }
                    }
                }
                    /* Class */
                else if p.isClass {
                    if let classaz = p.classType as? NSObject.Type {
                        var obj = classaz.init()
                        if let error = FwiJSONMapper.mapObjectToModel(valueJson, model: &obj) {
                            errorUserInfo[p.propertyName] = error.userInfo
                        } else {
                            m.setValue(obj, forKey: p.propertyName)
                        }
                        
                    }
                }
                    /* Dictionary */
                else if p.isDictionary {
                    var value: [String: AnyObject] = [:]
                    defer {
                        if value.keys.count > 0 {
                            
                            //                            m.setValue(value, forKey: p.propertyName)
                            m.setValue(NSDictionary(dictionary: value), forKey: p.propertyName)
                        } else {
                            if !isOptional {
                                errorUserInfo[p.propertyName] = "Not Find Value For Key"
                            }
                        }
                    }
                    
                    if let type = p.dictionaryType {
                        if let classaz = type.value.classType as? NSObject.Type {
                            if type.key.isPrimitive {
                                if let dictItem = valueJson as? [String: AnyObject] {
                                    for (newKey, valueItem) in dictItem {
                                        var obj = classaz.init()
                                        if let error = FwiJSONMapper.mapObjectToModel(valueItem, model: &obj) {
                                            errorUserInfo[newKey] = error.userInfo
                                        } else {
                                            value[newKey] = obj
                                        }
                                    }
                                    
                                }
                            }
                        } else {
                            // try set value normal
                            value <- (valueJson as AnyObject?)
                        }
                        
                    } else {
                        // try set value normal
                        value <- (valueJson as AnyObject?)
                    }
                    
                }
                    /* Collection */
                else if p.isCollection {
                    var temp: [AnyObject] = []
                    defer {
                        if temp.count > 0 {
                            m.setValue(temp, forKey: p.propertyName)
                        } else {
                            if !isOptional {
                                errorUserInfo[p.propertyName] = "Not Find Value For Key"
                            }
                        }
                    }
                    if let type = p.collectionType {
                        if let classaz = type.classType as? NSObject.Type {
                            if let arrValue = valueJson as? [AnyObject] {
                                for (index, obj) in arrValue.enumerated() {
                                    var newObj = classaz.init()
                                    if let error = FwiJSONMapper.mapObjectToModel(obj, model: &newObj) {
                                        errorUserInfo["value\(index)"] = error.userInfo
                                    } else {
                                        temp.append(newObj)
                                    }
                                    
                                }
                                
                            }
                        } else {
                            temp <- (valueJson as? [AnyObject])
                        }
                        
                    } else {
                        // try set value normal
                        temp <- (valueJson as? [AnyObject])
                    }
                }
            }
        }
        
        if errorUserInfo.keys.count > 0 {
            return NSError(domain: NSURLErrorKey, code: NSURLErrorUnknown, userInfo: errorUserInfo)
        }
        return nil
    }
}


// MARK: Custom Operator
infix operator <-

public func <- <T>(left: inout T, right: AnyObject?) {
    if let value = right as? T {
        left = value
    }
}
public func <- <T>(left: inout T?, right: AnyObject?) {
    left = right as? T
}

public func <- <T: NSObject>(left: inout T, right: AnyObject?) {
    let _ = FwiJSONMapper.mapObjectToModel(right, model: &left)
}

public func <- <T>(left: inout [T], right: [AnyObject]?) {
    if let arrValue = right {
        var temp = [T]()
        
        arrValue.forEach {
            if let value = $0 as? T {
                temp.append(value)
            }
        }
        
        if temp.count > 0 {
            left = temp
        }
    }
}
public func <- <T>(left: inout [T]?, right: [AnyObject]?) {
    if let arrValue = right {
        var temp = [T]()
        
        arrValue.forEach {
            if let value = $0 as? T {
                temp.append(value)
            }
        }
        
        if temp.count > 0 {
            left = temp
        }
    }
}
