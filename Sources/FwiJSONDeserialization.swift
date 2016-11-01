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

extension NSObject: FwiJSONDeserialization {
    public typealias Model = NSObject
}

/// FwiJSONDeserialization is only work when Model is an instance of NSObject.
public extension FwiJSONDeserialization where Self: NSObject  {

    /// Build a list of models.
    ///
    /// - parameter array (required): a list of keys-values
    public static func map(array a: [[String: Any]]) -> ([Self]?, Error?) {
        let result = FwiJSONMapper.map(array: a, toModel: self)
        return (result.0, result.1)
    }

    /// Create model's instance and map dictionary to that instance.
    ///
    /// - parameter dictionary (required): set of keys-values
    public static func map(dictionary d: [String : Any]) -> (Self?, Error?) {
        let result = FwiJSONMapper.map(dictionary: d, toModel: self)
        return (result.0, result.1)
    }
}






