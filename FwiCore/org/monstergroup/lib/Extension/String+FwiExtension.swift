//  Project name: FwiCore
//  File name   : String+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/22/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
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
//  testing. Monster Group  disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import Foundation


public extension String {
   
    /** Generate random identifier base on uuid. */
    public static func randomIdentifier() -> String? {
        var uuidRef  = CFUUIDCreate(nil)
        var cfString = CFUUIDCreateString(nil, uuidRef)
        
        return cfString as? String
    }
    
    /** Generate timestamp string. */
    public static func timestamp() -> String? {
        return "\(time(nil))"
    }
    
    
    /** Compare 2 string regardless case sensitive. */
    public func isEqualToStringIgnoreCase(otherString: String?) -> Bool {
        /* Condition validation */
        if (otherString == nil) {
            return false
        }
        
        var text1 = otherString?.lowercaseString.trim()
        var text2 = self.lowercaseString.trim()
        return (text1 == text2)
    }
    
    /** Validate string. */
    public func matchPattern(pattern: String) -> Bool {
        /* Condition validation */
        if (count(pattern) <= 0) {
            return false
        }
        return self.matchPattern(pattern, expressionOption: NSRegularExpressionOptions.CaseInsensitive)
    }
    public func matchPattern(pattern: String, expressionOption option: NSRegularExpressionOptions) -> Bool {
        /* Condition validation */
        if (count(pattern) <= 0) {
            return false
        }
        
        var error: NSError? = nil
        var regex = NSRegularExpression(pattern: pattern, options: option, error: &error)
        
        var matches = regex?.numberOfMatchesInString(self, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, count(self)))
        return (matches != nil ? matches! == 1 : false)
    }
    
    /** Convert string to data. */
    public func toData() -> NSData? {
        return self.toDataWithEncoding(NSUTF8StringEncoding)
    }
    public func toDataWithEncoding(encoding: NSStringEncoding) -> NSData? {
        return self.dataUsingEncoding(encoding, allowLossyConversion: false)
    }
    
    /** Convert html string compatible to string. */
    public func decodeHTML() -> String? {
        return CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, self, "", CFStringBuiltInEncodings.UTF8.rawValue) as? String
    }
    /** Convert string to html string compatible. */
    public func encodeHTML() -> String? {
        return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, self, nil, ":/=,!$&'()*+[]@#?", CFStringBuiltInEncodings.UTF8.rawValue) as? String
    }
    
    /** Split string into components. */
    public func splitWithSeparator(separator: String) -> [String]? {
        return self.componentsSeparatedByString(separator)
    }
    
    /** Trim all spaces before and after a string. */
    public func trim() -> String? {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}
