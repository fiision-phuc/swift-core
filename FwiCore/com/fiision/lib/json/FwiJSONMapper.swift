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


@objc(JSONMapper)
public class FwiJSONMapper: NSObject {

    // MARK: Class's constructors
    public override init() {
        super.init()
    }

    // MARK: Class's public methods
    /** Map Dictionary To Model */
    public func mapDictionaryToModel<T: NSObject>(dictionary: [String: AnyObject], inout model m: T) -> NSError? {
        var dictionary = dictionary
        let optionalProperties = (m as? FwiJSONModel)?.propertyIsOptional?() ?? []
        var properties = FwiReflector.propertiesWithClass(m.dynamicType)
        var errorUserInfo: [String: AnyObject] = [:]

        // Override dictionary if neccessary
        if let json = m as? FwiJSONModel {
            if let keyMapper = json.keyMapper?() {
                for (k, v) in keyMapper {
                    dictionary[v] = dictionary[k]
                    dictionary.removeValueForKey(k)
                }
            }

            // Filter Ignore property
            properties = properties.filter({ (json.propertyIsIgnored?($0.propertyName) ?? false) == false })
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
                    var value = p.lookupPrimitiveType("\(primitiveType)")

                    // Convert value first
                    value <- valueJson

                    // Check value nil and not optional
                    if value == nil && isOptional == false {
                        errorUserInfo[p.propertyName] = "Not Find Value For Key"
                    } else {

                        // Check exsist set key value
                        if m.respondsToSelector(NSSelectorFromString(p.propertyName)) {
                            m.setValue(value as? AnyObject, forKey: p.propertyName)
                        } else {
                            fatalError("Not Support Property Optional Bool, Int , Double!!!! , Try to don't using Optional")
                        }
                    }
                } else {
                    errorUserInfo[p.propertyName] = "Not found type for key"
                }

            } else {
                // Check Other Type
                /* Object */
                if p.isObject {
                    // NSURL
                    if p.classType == NSURL.self || p.classType == NSURL?.self {
                        var value: NSURL?
                        if let path = valueJson as? String {
                            // Valid URL
                            let validUrl = path.encodeHTML() ?? ""
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
                            value = classaz.init()
                            value <- valueJson

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
                            m.setValue(value, forKey: p.propertyName)
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
                                for (index, obj) in arrValue.enumerate() {
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

    // MARK: Class's private methods
    /** Convert value to NSDate*/
    private func transformDate(value: AnyObject?, format: String = "yyyy-MM-dd'T'HHmmssZZZ") -> NSDate? {
        if let number = value as? NSNumber {
            return NSDate(timeIntervalSince1970: number.doubleValue)
        }

        if let strDate = (value as? String)?.stringByReplacingOccurrencesOfString(":", withString: "") {
            let formatter = NSDateFormatter()
            formatter.dateFormat = format
            return formatter.dateFromString(strDate)
        }

        return nil
    }
}

// Creation
extension FwiJSONMapper {

    // MARK: Class's static constructors
    class func mapObjectToModel<T: NSObject>(object: AnyObject?, inout model m: T) -> NSError? {
        if let dictionary = object as? [String: AnyObject] {
            return FwiJSONMapper().mapDictionaryToModel(dictionary, model: &m)
        }

        return NSError(domain: NSURLErrorKey, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey: "Parse object to dictionary error !!!"])
    }

    class func toDictionary<T: NSObject>(object: T) -> [String: AnyObject] {
        var result: [String: AnyObject] = [:]

        // Create Mirror Value Follow Properties
        let mirror = Mirror(reflecting: object)

        // Reflector Object To Identify Type Properties
        let reflectorItems = FwiReflector.propertiesWithClass(object.dynamicType)

        // Create dictionary from object
        var dictionaryKey: [String: String] = [:]
        dictionaryKey = mirror.children.reduce(dictionaryKey, combine: { (temp, child) -> [String: String] in
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
                        dictionaryKey.removeValueForKey(value)
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
                result[keyJson] = value as? AnyObject
            } else {
                // Object
                if reflector.isObject {
                    // NSURL
                    if let url = value as? NSURL {
                        // Return a absolute string of url
                        result[keyJson] = url.absoluteString
                    }
                    // NSDate
                    else if let date = value as? NSDate {
                        // Return a double value
                        result[keyJson] = date.timeIntervalSince1970
                    }
                    // Try other
                    else if let obj = value as? AnyObject {
                        result[keyJson] = obj
                    }
                }
                // Class
                else if reflector.isClass {
                    //
                    if let obj = value as? NSObject {
                        // Tracking If Object has Init Function
                        if obj.respondsToSelector(#selector(obj.dynamicType.init)) {
                            let newDict = FwiJSONMapper.toDictionary(obj)
                            result[keyJson] = newDict
                        }
                    }
                }
                // Dictionary
                else if reflector.isDictionary {
                    // Create a dictionay temp
                    var temp: [String: AnyObject] = [:]

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
                                    if objDict.respondsToSelector(#selector(objDict.dynamicType.init)) {
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
                                        if objDict.respondsToSelector(#selector(objDict.dynamicType.init)) {
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
                                temp.append(valueItem)
                            } else {
                                if let newItem = valueItem as? NSObject {
                                    // Tracking If Object has Init Function
                                    if newItem.respondsToSelector(#selector(newItem.dynamicType.init)) {
                                        let newDict = FwiJSONMapper.toDictionary(newItem)
                                        temp.append(newDict)
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
