// Project name: FwiCore
//  File name   : NSData+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/22/14
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

public extension NSData {

    /** Convert data to UTF8 string. */
    public func toString() -> String? {
        return toStringWithEncoding(NSUTF8StringEncoding)
    }

    /** Convert data to string base on string encoding type. */
    public func toStringWithEncoding(encoding: NSStringEncoding) -> String? {
        /* Condition validation */
        if length <= 0 {
            return nil
        }
        return NSString(data: self, encoding: encoding) as? String
    }

    /** Clear all bytes data. */
    public func clearBytes() {
        /* Condition validation */
        if length <= 0 {
            return
        }

        let bytes = UnsafeMutablePointer<UInt8>(self.bytes)
        let step = length >> 1
        var end = length - 1

        for i in 0 ..< step {
            bytes[end] = 0
            bytes[i] = 0
            end -= 1
        }

        // Handle the last stand alone byte
        if (length % 2) == 1 {
            bytes[step] = 0
        }
    }

    /** Reverse the order of bytes. */
    public func reverseBytes() {
        /* Condition validation */
        if length <= 0 {
            return
        }

        let bytes = UnsafeMutablePointer<UInt8>(self.bytes)
        let step = length >> 1
        var end = length - 1

        for i in 0 ..< step {
            let temp = bytes[i]

            bytes[i] = bytes[end]
            bytes[end] = temp
            end -= 1
        }
    }
}
