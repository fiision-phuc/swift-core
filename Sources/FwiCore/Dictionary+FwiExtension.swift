//  File name   : Dictionary+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/26/16
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

public extension Dictionary {
    /// Load dictionary from plist.
    ///
    /// - Parameters:
    ///   - plistname: the plist's name
    ///   - bundle: which bundle contains the plist file
    public static func loadPlist(withPlistname n: String, fromBundle b: Bundle = Bundle.main) throws -> [String: Any] {
        guard let url = b.url(forResource: n, withExtension: "plist") else {
            let info = [NSLocalizedDescriptionKey: "\(n).plist does not exist."]
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: info)
        }

        let data = try Data(contentsOf: url)
        let rawData = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)

        // Cast to dictionary
        guard let plist = rawData as? [String: Any] else {
            let info = [NSLocalizedDescriptionKey: "\(n).plist is not in form of key-value."]
            throw NSError(domain: FwiCore.domain, code: -1, userInfo: info)
        }
        return plist
    }

    /// Lookup value for specific key. If value is not available, default value will be returned.
    ///
    /// - Parameters:
    ///   - key: a key to lookup
    ///   - defaultValue: default value to be returned
    func value<E>(for key: Key, defaultValue: @autoclosure () -> E) -> E {
        guard let result = self[key] as? E else {
            return defaultValue()
        }
        return result
    }

    /// Convert dictionary to data.
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [])
    }
}
