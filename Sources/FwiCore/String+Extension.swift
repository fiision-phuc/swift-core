//  File name   : String+Extension.swift
//
//  Author      : Phuc, Tran Huu
//  Editor      : Dung Vu
//  Created date: 11/22/14
//  --------------------------------------------------------------
//  Copyright © 2012, 2019 Fiision Studio. All Rights Reserved.
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
    /// Generate random identifier base on uuid.
    static var randomIdentifier: String {
        return UUID().uuidString
    }

    /// Generate timestamp string.
    static var timestamp: String {
        return "\(time(nil))"
    }

    /// Convert html string compatible to string.
    func decodeHTML() -> String {
        return removingPercentEncoding ?? ""
    }

    /// Convert string to html string compatible.
    func encodeHTML() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) ?? ""
    }

    /// Compare 2 string regardless case sensitive.
    ///
    /// - parameter otherString (required): other string to compare
    func isEqualTo(_ otherString: String?, ignoreCase: Bool = true) -> Bool {
        /* Condition validation */
        guard let otherString = otherString else {
            return false
        }

        var text1 = self.trim()
        var text2 = otherString.trim()

        if ignoreCase {
            text1 = text1.lowercased()
            text2 = text2.lowercased()
        }
        return text1 == text2
    }

    /// Validate string.
    ///
    /// - parameter pattern (required): regular expression to validate string
    /// - parameter expressionOption (optional): regular expression searching option
    func matchPattern(_ pattern: String, expressionOption: NSRegularExpression.Options = .caseInsensitive) -> Bool {
        /* Condition validation */
        if pattern.count <= 0 {
            return false
        }

        return FwiCore.tryOmitsThrow({
            let regex = try NSRegularExpression(pattern: pattern, options: expressionOption)
            let matches = regex.numberOfMatches(in: self, options: .anchored, range: NSMakeRange(0, count))
            return (matches == 1)
        }, default: false)
    }

    /// Split string into components.
    ///
    /// - parameter separator (required): string's separator
    func split(_ separator: String) -> [String] {
        return components(separatedBy: separator).compactMap { $0.count > 0 ? $0 : nil }
    }

    /// Trim all spaces before and after a string.
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// Convert string to data.
    func toData(dataEncoding: String.Encoding = .utf8) -> Data? {
        return data(using: dataEncoding, allowLossyConversion: false)
    }
}
