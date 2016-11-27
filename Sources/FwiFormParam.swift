//  Project name: FwiCore
//  File name   : FwiFormParam.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/3/14
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


public struct FwiFormParam: CustomDebugStringConvertible, CustomStringConvertible {

    // MARK: Class's constructors
    public init(key: String = "", value: String = "") {
        self.key = key
        self.value = value
    }

    // MARK: Class's properties
    public fileprivate (set) var key: String
    public fileprivate (set) var value: String

    // MARK: Struct's private methods
    public var hashValue: Int {
        return key.hashValue ^ value.hashValue
    }

    // MARK: CustomDebugStringConvertible's members
    public var debugDescription: String {
        return description
    }

    // MARK: CustomStringConvertible's members
    public var description: String {
        if key[0] == "#" {
            return "#\(key.substring(startIndex: 1).encodeHTML())=\(value.encodeHTML())"
        }
        return "\(key.encodeHTML())=\(value.encodeHTML())"
    }
}

// MARK: Custom Operator
public func < (left: FwiFormParam?, right: FwiFormParam?) -> Bool {
    /* Condition validation: Validate left nil */
    if left == nil && right != nil {
        return true
    }
    
    /* Condition validation: Validate right nil */
    if left != nil && right == nil {
        return false
    }
    
    guard let l = left, let r = right else {
        return false
    }
    
    if l.key[l.key.startIndex] == "#" && r.key[r.key.startIndex] != "#" {
        return true
    }
    else if l.key[l.key.startIndex] != "#" && r.key[r.key.startIndex] == "#" {
        return false
    }
    else if l.key[l.key.startIndex] == "#" && r.key[r.key.startIndex] == "#" {
        let key1 = l.key.substring(startIndex: 1, reverseIndex: 0)
        let key2 = r.key.substring(startIndex: 1, reverseIndex: 0)
        return key1 < key2
    }
    return l.key < r.key
}

public func == (left: FwiFormParam?, right: FwiFormParam?) -> Bool {
    return left?.hashValue == right?.hashValue
}
