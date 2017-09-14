//  Project name: FwiCore
//  File name   : FwiJSONEncodeOperator.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/31/17
//  Version     : 1.00
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


// MARK: Bool
internal func <-(left: inout Any?, right: Bool) {
    left = right
}

// MARK: Sign integer / Unsign integer / Float / Double
internal func <-(left: inout Any?, right: NSNumber) {
    left = right
}

// MARK: Data
internal func <-(left: inout Any?, right: Data) {
    guard let base64 = right.encodeBase64String() else {
        return
    }
    left = base64
}

// MARK: Date
internal func <-(left: inout Any?, right: Date) {
    left = dateFormatter.string(from: right)
}

// MARK: String
internal func <-(left: inout Any?, right: String) {
    left = right
}

// MARK: URL
internal func <-(left: inout Any?, right: URL) {
    left = right.absoluteString
}

// MARK: FwiJSON
internal func <-(left: inout Any?, right: FwiJSONModel) {
    guard let json = right.encode() else {
        return
    }
    left = json
}

// MARK: Array
internal func <-(left: inout Any?, right: [Any]) {
    if let v = right as? [Bool] {
        left = v
    } else if let v = right as? [NSNumber] {
        left = v
    } else if let v = right as? [Data] {
        let list = v.flatMap { $0.encodeBase64String() }.filter { $0.length() > 0 }
        if list.count > 0 {
            left = list
        }
    } else if let v = right as? [Date] {
        let list = v.flatMap { dateFormatter.string(from: $0) }
        if list.count > 0 {
            left = list
        }
    } else if let v = right as? [String] {
        if v.count > 0 {
            left = v
        }
    } else if let v = right as? [CustomStringConvertible] {
        let list = v.flatMap { $0.description }
        if list.count > 0 {
            left = list
        }
    } else if let v = right as? [URL] {
        let list = v.flatMap { $0.absoluteString }
        if list.count > 0 {
            left = list
        }
    } else if let v = right as? [FwiJSONModel] {
        let list = v.flatMap { $0.encode() }.filter { $0.count > 0 }
        if list.count > 0 {
            left = list
        }
    }
}

// MARK: Dictionary
internal func <-(left: inout Any?, right: [String:Any]) {
    if let v = right as? [String:Bool] {
        left = v
    } else if let v = right as? [String:NSNumber] {
        left = v
    } else if let v = right as? [String:Data] {
        let d = v.reduce([String:String](), { (origin, item) in
            guard let base64 = item.value.encodeBase64String() else {
                return origin
            }
            var origin = origin

            origin[item.key] = base64
            return origin
        })
        if d.count > 0 {
            left = d
        }
    } else if let v = right as? [String:Date] {
        let d = v.reduce([String:String](), { (origin, item) in
            var origin = origin

            origin[item.key] = dateFormatter.string(from: item.value)
            return origin
        })
        if d.count > 0 {
            left = d
        }
    } else if let v = right as? [String:String] {
        if v.count > 0 {
            left = v
        }
    } else if let v = right as? [String:CustomStringConvertible] {
        let d = v.reduce([String:String](), { (origin, item) in
            var origin = origin

            origin[item.key] = item.value.description
            return origin
        })
        if d.count > 0 {
            left = d
        }
    } else if let v = right as? [String:URL] {
        let d = v.reduce([String:String](), { (origin, item) in
            var origin = origin

            origin[item.key] = item.value.absoluteString
            return origin
        })
        if d.count > 0 {
            left = d
        }
    } else if let v = right as? [String:FwiJSONModel] {
        let d = v.reduce([String:JSON](), { (origin, item) in
            guard let json = item.value.encode() else {
                return origin
            }
            var origin = origin

            origin[item.key] = json
            return origin
        })
        if d.count > 0 {
            left = d
        }
    }
}
