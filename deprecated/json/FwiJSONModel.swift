//  Project name: FwiCore
//  File name   : FwiJSONModel.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 6/10/16
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


/// Define JSON type alias.
public typealias JSON = [String : Any]


/// FwiJSONModel represents a JSON model. This protocol is required in order to let FwiReflector
/// working properly.
public protocol FwiJSONModel {

    init(withJSON aJSON: JSON)

    func encode() -> JSON?



    /// Define keys mapper.
    var keyMapper: [String:String]? { get }

    /// Define ignored properties.
    var ignoreProperties: [String]? { get }

    /// Define optional properties.
    var optionalProperties: [String]? { get }

    /// Allow developer to interact directly with json dictionary before mapping process.
    ///
    /// parameter original (required): original json dictionary
    func convertJSON(fromOriginal original: JSON) -> JSON
}

/// An extension to help FwiReflector and FwiJSONMapper.
public extension FwiJSONModel {

    public func encode() -> JSON? {
        // Find properties' sequences
        let s = sequence(first: Mirror(reflecting: self), next: {
            guard let superMirror = $0.superclassMirror, superMirror.subjectType != NSObject.self else {
                return nil
            }
            return superMirror
        })
        .flatMap { $0.children }

        // Define JSON
        var d = JSON(minimumCapacity: s.count)

        s.forEach { (k, v) in
            guard let key = k else {
                return
            }

            if let aBool = v as? Bool {
                d[key] = aBool
            } else if let aNumber = v as? NSNumber {
                d[key] <- aNumber
            } else if let aData = v as? Data {
                d[key] <- aData
            } else if let aDate = v as? Date {
                d[key] <- aDate
            } else if let aString = v as? String {
                d[key] <- aString
            } else if let aCustom = v as? CustomStringConvertible {
                d[key] <- aCustom.description
            } else if let aUrl = v as? URL {
                d[key] <- aUrl
            } else if let aModel = v as? FwiJSONModel {
                d[key] <- aModel
            } else if let aArray = v as? [Any] {
                d[key] <- aArray
            } else if let aDictionary = v as? [String:Any] {
                d[key] <- aDictionary
            } else {
                let m = Mirror(reflecting: v)
                guard m.children.count == 1, let v = m.children.first else {
                    return
                }

                if let value = v.value as? FwiJSONModel {
                    d[key] <- value
                }
            }
        }
        return d.count > 0 ? d : nil
    }

    /// Default implementation for keys mapper.
    public var keyMapper: [String:String]? {
        return nil
    }

    /// Default implementation for ignored properties.
    public var ignoreProperties: [String]? {
        return nil
    }

    /// Default implementation for optional properties.
    public var optionalProperties: [String]? {
        return nil
    }

    /// Default implementation for convertJSON function.
    public func convertJSON(fromOriginal original: JSON) -> JSON {
        return original
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
/// FwiJSONManual represents a manual JSON model where developer wish to perform custom mapping.
public protocol FwiJSONManual {

    /// Allow developer to perform custom map.
    ///
    /// parameter object (required): object json
    @discardableResult
    func map(object o: JSON) -> Error?
}
