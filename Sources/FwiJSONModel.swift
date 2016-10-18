//  Project name: FwiCore
//  File name   : FwiJSONModel.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 6/10/16
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


/// FwiJSONModel represents a JSON model. This protocol is required in order to let FwiReflector
/// working properly.
public protocol FwiJSONModel {

    /// Define keys mapper.
    var keyMapper: [String:String]? { get }

    /// Define ignored properties.
    var ignoreProperties: [String]? { get }

    /// Define optional properties.
    var optionalProperties: [String]? { get }

    /// Allow developer to interact directly with json dictionary before mapping process.
    ///
    /// parameter original (required): original json dictionary
    func convertJSON(fromOriginal original: [String:Any]) -> [String:Any]
}


/// An extension to help FwiReflector and FwiJSONMapper.
public extension FwiJSONModel where Self: FwiJSONModel {

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
    public func convertJSON(fromOriginal original: [String:Any]) -> [String:Any] {
        return original
    }
}

/// FwiJSONManual represents a manual JSON model where developer wish to perform custom mapping.
public protocol FwiJSONManual {

    /// Allow developer to perform custom map.
    ///
    /// parameter object (required): object json
    @discardableResult
    func map(object o: [String: Any]) -> NSError?
}
