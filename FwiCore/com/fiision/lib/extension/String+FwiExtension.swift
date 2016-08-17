//  Project name: FwiCore
//  File name   : String+FwiExtension.swift
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


public extension String {

    /** Generate random identifier base on uuid. */
    public static func randomIdentifier() -> String? {
        if let uuidRef = CFUUIDCreate(nil), cfString = CFUUIDCreateString(nil, uuidRef) {
            return cfString as String
        }
        return nil
    }

    /** Generate timestamp string. */
    public static func timestamp() -> String {
        return "\(time(nil))"
    }

    /** Compare 2 string regardless case sensitive. */
    public func isEqualToStringIgnoreCase(otherString: String?) -> Bool {
        /* Condition validation */
        if otherString == nil {
            return false
        }

        let (text1, text2) = (self.lowercaseString.trim(), otherString?.lowercaseString.trim())
        return text1 == text2
    }

    /** Validate string. */
    public func matchPattern(pattern: String, expressionOption option: NSRegularExpressionOptions = .CaseInsensitive) -> Bool {
        /* Condition validation */
        if pattern.length() <= 0 {
            return false
        }

        let regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: option)

            if let matches = regex?.numberOfMatchesInString(self, options: .Anchored, range: NSMakeRange(0, self.length())) {
                return (matches == 1)
            }
        } catch _ {
            // Ignore error and suppose it is not matched pattern.
        }
        return false
    }

    /** Calculate string length. */
    public func length() -> Int {
        return characters.count
    }

    /** Convert string to data. */
    public func toData(encoding: NSStringEncoding = NSUTF8StringEncoding) -> NSData? {
        return dataUsingEncoding(encoding, allowLossyConversion: false)
    }

    /** Convert html string compatible to string. */
    public func decodeHTML() -> String {
        return CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, self, "") as String
    }
    /** Convert string to html string compatible. */
    public func encodeHTML() -> String {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet(charactersInString: ":/=,!$&'()*+[]@#?")) ?? ""
    }

    /** Split string into components. */
    public func split(separator: String) -> [String] {
        return componentsSeparatedByString(separator)
    }

    /** Sub string from index to reverse index. */
    func substring(startIndex strIndex: Int, reverseIndex endIndex: Int) -> String {
        let range = self.startIndex.advancedBy(strIndex) ..< self.endIndex.advancedBy(endIndex)
        return substringWithRange(range)
    }

    /** Trim all spaces before and after a string. */
    public func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}
