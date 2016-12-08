//  Project name: FwiCore
//  File name   : FwiJSONSerialization.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 10/31/16
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


/// FwiJSONSerialization defines default functions to convert model to JSON.
public protocol FwiJSONSerialization {
}

/// FwiJSONSerialization is only work when Model is an instance of NSObject.
public extension FwiJSONSerialization {
    public typealias Model = Self
}

////////////////////////////////////////////////////////////////////////////////////////////////////
/// It's only using for non-generic.
extension NSObject: FwiJSONSerialization {
}

public extension FwiJSONSerialization where Self: NSObject {
    
    /// Convert model to dictionary.
    public func toDictionary() -> JSON {
        return FwiJSONMapper.convert(model: self)
    }
    
    /// Convert model to JSON as data.
    public func toJSONData() -> Data? {
        let d = toDictionary()
        return try? JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
    
    /// Convert model to JSON as string.
    public func toJSONString() -> String? {
        return toJSONData()?.toString()
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
/// Class using for convert, because FwiJSONSerialization is dynamic protocol, using this for
/// generic object.
public final class FwiJSONConvert<T: NSObject> {
    
    /// Build a list from a list of models.
    ///
    /// - parameter array (required): a list of models
    public static func convert(array a: [T]) -> [JSON] {
        return FwiJSONMapper.convert(array: a)
    }
}
