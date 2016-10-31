//  Project name: FwiCore
//  File name   : FwiJSONDeserialization.swift
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


/// FwiJSONDeserialization defines default functions to convert JSON to model.
public protocol FwiJSONDeserialization {
    associatedtype Model
}


/// FwiJSONDeserialization is only work when Model is an instance of NSObject.
public extension FwiJSONDeserialization where Model: NSObject {
    
    /// Build a list of model.
    ///
    /// - parameter array (required): a list of keys-values
    @discardableResult
    public static func map(array a: [[String : Any]]) -> ([Model]?, Error?) {
        var userInfo = [String]()
        var models = [Model]()
        for (idx, d) in a.enumerated() {
            var o = Model.init()
            
//            guard map(dictionary: d, toObject: &o) == nil else {
//                userInfo.append("Could not create 'object' at index: \(idx)")
//                continue
//            }
            models.append(o)
        }
        
        // Summary error
        if userInfo.count > 0 {
            return (nil, NSError(domain: "FwiJSONDeserialization", code: -1, userInfo: ["userInfo":userInfo]))
        }
        return (models, nil)
    }
    
//    /// Create model's instance and map dictionary to that instance.
//    ///
//    /// - parameter dictionary (required): set of keys-values
//    public static func map(dictionary d: [String : Any]) -> (Model, Error?) {
//        var m = Model.init()
//        
//        /* Condition validation: should allow model to perform manual mapping or not */
//        if let j = m as? FwiJSONManual {
//            return (m, j.map(object: d))
//        }
//        
//        var properties = FwiReflector.properties(withObject: m)
//        var userInfo = [String : Any]()
//        var dictionary = d
//        
//        // Override dictionary if model implement FwiJSONModel
//        if let j = m as? FwiJSONModel {
//            dictionary <- j
//            properties <- j
//        }
//        
//        // Inject data into object's properties
//        for p in properties {
//            /* Condition validation: validate JSON base on https://tools.ietf.org/html/rfc7159#section-2 */
//            guard let valueJSON = dictionary[p.mirrorName], !(valueJSON is NSNull) || valueJSON is NSNumber || valueJSON is String || valueJSON is [Any] || valueJSON is [String : Any] else {
//                if !p.optionalProperty { userInfo[p.mirrorName] = "Could not map 'value' to property: '\(p.mirrorName)' because of incorrect JSON grammar: '\(dictionary[p.mirrorName])'." }
//                continue
//            }
//            
//            var value = valueJSON
//            var canAssign = false
//            if let a = value as? [Any], p.isCollection || p.isSet {
//                if let objects = a as? [[String : Any]], let collectionType = p.collectionType, let c = collectionType.classType as? NSObject.Type {
//                    let (list, _) = map(array: objects, toModel: c)
//                    if let l = list {
//                        value = l
//                        canAssign = true
//                    }
//                } else {
//                    if let array = a + p {
//                        value = array
//                        canAssign = true
//                    }
//                }
//            } else if let d = value as? [String : Any], p.isDictionary || p.isObject {
//                if p.isObject {
//                    if let c = p.classType as? NSObject.Type {
//                        let (child, _) = map(dictionary: d, toModel: c)
//                        if let c = child {
//                            value = c
//                            canAssign = true
//                        }
//                    }
//                } else {
//                    if let dictionary = d + p {
//                        value = dictionary
//                        canAssign = true
//                    }
//                }
//            } else {
//                if let n = value as? NSNumber, p.isStruct && p.structType == Date.self {
//                    if let d = transformDate(n) {
//                        value = d
//                        canAssign = true
//                    }
//                } else if let s = value as? String {
//                    if let v = s + p {
//                        value = v
//                        canAssign = true
//                    }
//                } else {
//                    canAssign = true
//                }
//            }
//            
//            // Assign value to property if can
//            if canAssign && m.responds(to: NSSelectorFromString(p.mirrorName)) == true {
//                m.setValue(value, forKey: p.mirrorName)
//            } else {
//                if !p.optionalProperty {
//                    userInfo[p.mirrorName] = "Could not map '\(value)' to this property due to data's type conflict."
//                }
//                
//            }
//        }
//        
//        // Summary error
//        if userInfo.keys.count > 0 {
//            var message = "\nThere is an error when trying to map data into model: \(NSStringFromClass(type(of: m)))\n"
//            userInfo.forEach({
//                message += "-> [\($0)] \($1)\n"
//            })
//            FwiLog(message)
//            
//            return NSError(domain: "FwiJSONMapper", code: -1, userInfo: userInfo)
//        }
//        return nil
//    }
}
