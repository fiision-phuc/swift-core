//  Project name: FwiCore
//  File name   : NSString+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/26/14
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


public extension NSString {

    /** Generate random identifier base on uuid. */
    public class func randomIdentifier() -> String? {
        return String.randomIdentifier()
    }

    /** Generate timestamp string. */
    public class func timestamp() -> String {
        return String.timestamp()
    }

    /** Compare 2 string regardless case sensitive. */
    public func isEqualToStringIgnoreCase(otherString: String?) -> Bool {
        return (self as String).isEqualToStringIgnoreCase(otherString)
    }

    /** Validate string. */
    public func matchPattern(pattern: String, expressionOption option: NSRegularExpressionOptions = .CaseInsensitive) -> Bool {
        return (self as String).matchPattern(pattern, expressionOption: option)
    }

    /** Convert string to data. */
    public func toData(encoding: NSStringEncoding = NSUTF8StringEncoding) -> NSData? {
        return (self as String).toData(encoding)
    }

    /** Convert html string compatible to string. */
    public func decodeHTML() -> String {
        return (self as String).decodeHTML()
    }
    /** Convert string to html string compatible. */
    public func encodeHTML() -> String {
        return (self as String).encodeHTML()
    }

    /** Split string into components. */
    public func split(separator: String) -> [String] {
        return (self as String).split(separator)
    }

    /** Trim all spaces before and after a string. */
    public func trim() -> String {
        return (self as String).trim()
    }
}
