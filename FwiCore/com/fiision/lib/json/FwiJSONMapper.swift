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


public final class FwiJSONMapper {

    // MARK: Class's constructors
    public init() {
    }

    // MARK: Class's public methods
    /// Map dictionary to model.
    ///
    /// - parameter dictionary: set of keys-values.
    /// - parameter model: a class which contains a set of properties to be mapped.
    @discardableResult
    public func mapDictionary<T: NSObject>(dictionary d: [String:Any], toModel m: inout T) -> NSError? {
        var properties = FwiReflector.properties(withClass: T.self)
        var errorInfo = [String: Any]()
        var dictionary = d

        // Override dictionary if model implement FwiJSONModel
        if let j = m as? FwiJSONModel {
            // Remove ignore properties
            if let ignoreProperties = j.ignoreProperties?() {
                properties = properties.filter({ ignoreProperties.contains($0.mirrorName) == false })
            }

            // Apply optional properties 
            if let optionalProperties = (m as? FwiJSONModel)?.optionalProperties?() {
                properties.forEach({
                    if optionalProperties.contains($0.mirrorName) {
                        $0.optionalProperty = true
                    }
                })
            }

            // Apply key map
            if let keyMapper = j.keyMapper?() {
                for (k, v) in keyMapper {
                    dictionary[v] = dictionary[k]
                    dictionary.removeValue(forKey: k)
                }
            }
        }

        // Map values to properties
        for p in properties {
            guard let valueJSON = dictionary[p.mirrorName], !(valueJSON is NSNull) else {
                if !p.optionalProperty {
                    errorInfo[p.propertyName] = "\(p.mirrorName) is missing."
                }
                continue
            }
            var value = valueJSON
            var canAssign = false

//            if let a = valueJSON as? [Any]/*, p.isObject && (p.isCollection || p.isSet)*/ {         // Try to match value type with property type
//                FwiLog("a: \(a)")
//            }
//            else if let d = valueJSON as? [String:Any]/*, p.isObject && !(p.isCollection || p.isSet) && !p.isDictionary*/ {
//                FwiLog("d: \(d)")
//                if let c = p.classType as? NSObject.Type {
//                    var o = c.init()
//                    mapDictionary(dictionary: d, toModel: &o)
//
//                    value = o
//                }
//            }
//            else if let numberString = value as? String {                                           // Try to convert string to primitive
//                if p.isPrimitive {
//                    value = numberFormat.number(from: numberString)
//                }
//                else if p.isStruct && p.structType == URL.self {
//                    value = URL(string: numberString.encodeHTML())
//                }
//                else if p.isStruct && p.structType == Date.self {
//
//                }
//            }
//            m.setValue(value, forKey: p.mirrorName)


            // Check primitiveType first , because it's basic and easy

            if let primitiveType = p.primitiveType, p.isPrimitive {
                if let string = value as? String, primitiveType != String.self {
                    value = numberFormat.number(from: string)
                }
                canAssign = (type(of: value) == primitiveType)
            }
            else if let structType = p.structType, p.isStruct {
                if let string = value as? String, structType == URL.self || structType == Date.self {
                    if structType == URL.self {
                        let validUrl = string.encodeHTML()
                        value = URL(string: validUrl)
                    }
                    else if structType == Date.self {
                        value = self.transformDate(value as AnyObject?) as? Date
                    }
                }
                else {
                    // Generate error here (missing struct type).
                    fatalError("Not support , only url and date")
                }
            }
            else if p.isObject {

//                        // Try Other
//                    else {
//                        var value: AnyObject?
//                        if let classaz = p.classType as? NSObject.Type {
//                            var obj = classaz.init()
//                            obj <- valueJson
//                            value = obj
//
//
//                            if value == nil && isOptional == false {
//                                errorUserInfo[p.propertyName] = "Not Find Value For Key"
//                            } else {
//                                m.setValue(value, forKey: p.propertyName)
//                            }
//                        }
//                    }
//                }
//                    /* Class */
//                else if p.isClass {
//                    if let classaz = p.classType as? NSObject.Type {
//                        var obj = classaz.init()
//                        if let error = FwiJSONMapper.mapObjectToModel(valueJson, model: &obj) {
//                            errorUserInfo[p.propertyName] = error.userInfo
//                        } else {
//                            m.setValue(obj, forKey: p.propertyName)
//                        }
//
//                    }
//                }
//                    /* Dictionary */
//                else if p.isDictionary {
//                    var value: [String: AnyObject] = [:]
//                    defer {
//                        if value.keys.count > 0 {
//
//                            //                            m.setValue(value, forKey: p.propertyName)
//                            m.setValue(NSDictionary(dictionary: value), forKey: p.propertyName)
//                        } else {
//                            if !isOptional {
//                                errorUserInfo[p.propertyName] = "Not Find Value For Key"
//                            }
//                        }
//                    }
//
//                    if let type = p.dictionaryType {
//                        if let classaz = type.value.classType as? NSObject.Type {
//                            if type.key.isPrimitive {
//                                if let dictItem = valueJson as? [String: AnyObject] {
//                                    for (newKey, valueItem) in dictItem {
//                                        var obj = classaz.init()
//                                        if let error = FwiJSONMapper.mapObjectToModel(valueItem, model: &obj) {
//                                            errorUserInfo[newKey] = error.userInfo
//                                        } else {
//                                            value[newKey] = obj
//                                        }
//                                    }
//
//                                }
//                            }
//                        } else {
//                            // try set value normal
//                            value <- valueJson
//                        }
//
//                    } else {
//                        // try set value normal
//                        value <- valueJson
//                    }
//
//                }
//                    /* Collection */
//                else if p.isCollection {
//                    var temp: [AnyObject] = []
//                    defer {
//                        if temp.count > 0 {
//                            m.setValue(temp, forKey: p.propertyName)
//                        } else {
//                            if !isOptional {
//                                errorUserInfo[p.propertyName] = "Not Find Value For Key"
//                            }
//                        }
//                    }
//                    if let type = p.collectionType {
//                        if let classaz = type.classType as? NSObject.Type {
//                            if let arrValue = valueJson as? [AnyObject] {
//                                for (index, obj) in arrValue.enumerated() {
//                                    var newObj = classaz.init()
//                                    if let error = FwiJSONMapper.mapObjectToModel(obj, model: &newObj) {
//                                        errorUserInfo["value\(index)"] = error.userInfo
//                                    } else {
//                                        temp.append(newObj)
//                                    }
//
//                                }
//
//                            }
//                        } else {
//                            temp <- (valueJson as? [AnyObject])
//                        }
//
//                    } else {
//                        // try set value normal
//                        temp <- (valueJson as? [AnyObject])
//                    }
//                }
//            }
        }


            if canAssign && m.responds(to: NSSelectorFromString(p.mirrorName)) {
                m.setValue(value, forKey: p.mirrorName)
            }

//        if errorUserInfo.keys.count > 0 {
//            return NSError(domain: NSURLErrorKey, code: NSURLErrorUnknown, userInfo: errorUserInfo)
//        }




        }
        return nil
    }

    // MARK: Class's private methods
    fileprivate var numberFormat: NumberFormatter = {
        return NumberFormatter()
    }()

    /** Convert value to NSDate*/
    fileprivate func transformDate(_ value: AnyObject?, format: String = "yyyy-MM-dd'T'HHmmssZZZ") -> NSDate? {
        if let number = value as? NSNumber {
            return NSDate(timeIntervalSince1970: number.doubleValue)
        }

        if let strDate = (value as? String)?.replacingOccurrences(of: ":", with: "") {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            guard let newDate = formatter.date(from: strDate) else {
                return nil
            }
            
            return NSDate(timeIntervalSince1970: newDate.timeIntervalSince1970)
        }

        return nil
    }
}

// Creation
public extension FwiJSONMapper {

    // MARK: Class's static constructors
    public class func mapObjectToModel<T: NSObject>(_ object: Any?, model m: inout T) -> NSError? {
        if let dictionary = object as? [String: AnyObject] {
            return FwiJSONMapper().mapDictionaryToModel(dictionary, model: &m)
        }

        return NSError(domain: NSURLErrorKey, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: "Parse object to dictionary error !!!"])
    }

    public class func toDictionary<T: NSObject>(_ object: T) -> [String: Any] {
        var result: [String: Any] = [:]

        // Create Mirror Value Follow Properties
        let mirror = Mirror(reflecting: object)

        // Reflector Object To Identify Type Properties
        let reflectorItems = FwiReflector.properties(withClass: type(of: object))

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
            if let keyMapper = jsonModel.keyMapper?() {
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
            let value = mirror.children.filter({ $0.label == nameProperty }).first?.value

            // Find Reflector of property
            guard let reflector = reflectorItems.filter({ $0.propertyName == nameProperty }).first else {
                // nil , it can't identify
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
    public func mapDictionaryToModel<T: NSObject>(_ dictionary: [String: AnyObject], model m: inout T) -> NSError? {
        var dictionary =  (m as? FwiJSONModel)?.convertJson?(from: dictionary) ?? dictionary
        let optionalProperties = (m as? FwiJSONModel)?.propertyIsOptional?() ?? []
        var properties = FwiReflector.properties(withClass: type(of: m))
        var errorUserInfo: [String: Any] = [:]
        
        // Override dictionary if neccessary
        if let json = m as? FwiJSONModel {
            if let keyMapper = json.keyMapper?() {
                for (k, v) in keyMapper {
                    dictionary[v] = dictionary[k]
                    dictionary.removeValue(forKey: k)
                }
            }
            
            // Filter Ignore property
            properties = properties.filter({ (json.propertyIsIgnored?($0.mirrorName) ?? false) == false })
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
                    value <- valueJson
                    
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
                        
                        value = self.transformDate(valueJson) as? Date
                        
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
                        
                        value = self.transformDate(valueJson)
                        
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
                            obj <- valueJson
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
                            value <- valueJson
                        }
                        
                    } else {
                        // try set value normal
                        value <- valueJson
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
