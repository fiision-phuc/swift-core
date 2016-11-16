//  Project name: FwiCore
//  File name   : FwiJSONSerialization.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 10/31/16
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


/// FwiJSONSerialization defines default functions to convert model to JSON.
public protocol FwiJSONSerialization {
}

/// FwiJSONSerialization is only work when Model is an instance of NSObject.
public extension FwiJSONSerialization {
    public typealias Model = Self
}

public extension FwiJSONSerialization where Self: NSObject {

//    public func toDictionary() -> [String: Any] {
//        var result: [String: Any] = [:]
//
//        // Create Mirror Value Follow Properties
//        let mirror = Mirror(reflecting: self)
//
//        // Reflector Object To Identify Type Properties
//        let reflectorItems = FwiReflector.properties(withObject: self)
//
//        // Create dictionary from object
//        var dictionaryKey: [String: String] = [:]
//        dictionaryKey = mirror.children.reduce(dictionaryKey, { (temp, child) -> [String: String] in
//            var temp = temp
//
//            if let label = child.label {
//                temp[label] = label
//            }
//            return temp
//        })
//
//        // Tracking if it has swap key
//        if let jsonModel = object as? FwiJSONModel {
//            // Check It Has KeyMapper
//            if let keyMapper = jsonModel.keyMapper {
//                // Swap Key
//                for (key, value) in keyMapper {
//                    if dictionaryKey[value] != nil {
//                        dictionaryKey.removeValue(forKey: value)
//                        dictionaryKey[key] = value
//                    }
//                }
//            }
//        }
//
//        // Loop in Dictionary Key To Find Result
//        for (keyJson, nameProperty) in dictionaryKey {
//            // Find Value Of Properties
//            //            let value = mirror.children.first(where: {$0.label == nameProperty})?.value
//
//            // Find Reflector of property
//            guard let reflector = reflectorItems.first(where: { $0.propertyName == nameProperty }), let value = mirror.children.first(where: {$0.label == nameProperty})?.value else {
//                //                // nil , it can't identify
//                continue
//            }
//
//            // if it is primity type
//            if reflector.isPrimitive {
//                result[keyJson] = self.convertValueToString(from: value)
//            } else {
//                // Struct
//                if reflector.isStruct {
//                    // NSURL
//                    if let url = value as? URL {
//                        // Return a absolute string of url
//                        result[keyJson] = url.absoluteString
//                    }
//                        // NSDate
//                    else if let date = value as? Date {
//                        // Return a double value
//                        result[keyJson] = date.timeIntervalSince1970
//                    }
//                        // Try other
//                    else {
//                        result[keyJson] = value
//                    }
//                }
//                    // Object
//                else if reflector.isObject {
//                    // NSURL
//                    if let url = value as? NSURL {
//                        // Return a absolute string of url
//                        result[keyJson] = url.absoluteString
//                    }
//                        // NSDate
//                    else if let date = value as? NSDate {
//                        // Return a double value
//                        result[keyJson] = date.timeIntervalSince1970
//                    }
//                        // Try other
//                    else {
//                        result[keyJson] = value
//                    }
//                }
//                    // Class
//                else if reflector.isClass {
//                    //
//                    if let obj = value as? NSObject {
//                        // Tracking If Object has Init Function
//                        if obj.responds(to: #selector(type(of: obj).init)) {
//                            let newDict = FwiJSONMapper.toDictionary(obj)
//                            result[keyJson] = newDict
//                        }
//                    }
//                }
//                    // Dictionary
//                else if reflector.isDictionary {
//                    // Create a dictionay temp
//                    var temp: [String: Any] = [:]
//
//                    defer {
//                        if temp.keys.count > 0 {
//                            result[keyJson] = temp
//                        }
//                    }
//
//                    // Cast to choice dictionary type
//                    if let newDict = value as? [String: AnyObject] {
//                        // Loop in new dict to find value
//                        for (key, newValue) in newDict {
//                            // Check Value type
//                            let reflectItem = FwiReflector(mirrorName: key, mirrorValue: newValue)
//                            if reflectItem.isPrimitive || newValue is String || newValue is NSNumber {
//                                temp[key] = newValue
//                            } else {
//                                // Other
//                                if let objDict = newValue as? NSObject {
//                                    // Tracking If Object has Init Function
//                                    if objDict.responds(to: #selector(type(of: objDict).init)) {
//                                        let dictObj = FwiJSONMapper.toDictionary(objDict)
//                                        temp[key] = dictObj
//                                    }
//                                }
//                            }
//                        }
//                    }
//                        // Try to NSDictionary
//                    else if let newDict = value as? NSDictionary {
//                        // Loop in new dict to find value
//                        for (key, newValue) in newDict {
//                            if let keyPath = key as? String {
//                                // Loop in new dict to find value
//                                // Check Value type
//                                let reflectItem = FwiReflector(mirrorName: keyPath, mirrorValue: newValue)
//                                if reflectItem.isPrimitive || newValue is String || newValue is NSNumber {
//                                    temp[keyPath] = newValue
//                                } else {
//                                    // Other
//                                    if let objDict = newValue as? NSObject {
//                                        // Tracking If Object has Init Function
//                                        if objDict.responds(to: #selector(type(of: objDict).init)) {
//                                            let dictObj = FwiJSONMapper.toDictionary(objDict)
//                                            temp[keyPath] = dictObj
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                    // Collection
//                else if reflector.isCollection {
//                    // Create Array temp
//                    var temp: [AnyObject] = []
//                    defer {
//                        if temp.count > 0 {
//                            result[keyJson] = temp
//                        }
//                    }
//
//                    if let arrItem = value as? NSArray {
//                        for valueItem in arrItem {
//                            let reflect = FwiReflector(mirrorName: "", mirrorValue: valueItem)
//                            if reflect.isPrimitive || valueItem is String || valueItem is NSNumber {
//                                temp.append(valueItem as AnyObject)
//                            } else {
//                                if let newItem = valueItem as? NSObject {
//                                    // Tracking If Object has Init Function
//                                    if newItem.responds(to: #selector(type(of: newItem).init)) {
//                                        let newDict = FwiJSONMapper.toDictionary(newItem)
//                                        temp.append(newDict as AnyObject)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        return result
//    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
/// It's only using for non-generic.
extension NSObject: FwiJSONSerialization {
}
