//  Project name: FwiCore
//  File name   : URL+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/22/14
//  --------------------------------------------------------------
//  Copyright © 2012, 2017 Fiision Studio. All Rights Reserved.
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


public extension URL {

    /// URL to main cache folder.
    public static func cacheDirectory() -> URL? {
        let array = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return array.first
    }

    /// URL to main document folder.
    public static func documentDirectory() -> URL? {
        let array = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return array.first
    }
}

// MARK: Custom Operator
public extension URL {

    /// Append path component.
    public static func +(left: URL, right: String) -> URL {
        if left.absoluteString.hasSuffix("/") && right.hasPrefix("/") {
            return left.appendingPathComponent(right.substring(startIndex: 1))
        }
        return left.appendingPathComponent(right)
    }
    public static func +(left: URL, right: String?) -> URL {
        guard let path = right else {
            return left
        }
        return left + path
    }

    public static func +=(left: inout URL, right: String) {
        left = left + right
    }
    public static func +=(left: inout URL, right: String?) {
        guard let r = right else {
            return
        }
        left = left + r
    }

    /// Add query params to current url.
    public static func +(left: URL, right: [String:String]) -> URL {
        guard right.count > 0 else {
            return left
        }
        let forms = right.map { FwiFormParam(key: $0, value: $1) }
        let urlString = left.absoluteString

        // Define # if there is any
        let hashtag = forms.filter { $0.key[0] == "#"}
                          .sorted(by: <)
                          .first?.description ?? ""

        // Define query
        let query = forms.filter { $0.key[0] != "#" }
                        .sorted(by: <)
                        .map { $0.description }
                        .joined(separator: "&")

        // Finalize url
        let isHaveHashTag = hashtag.count > 0
        let isHaveQuery = query.count > 0

        switch (isHaveHashTag, isHaveQuery) {
        case (true, true):
            return URL(string: "\(urlString)\(hashtag)?\(query)") ?? left
        case (true, false):
            return URL(string: "\(urlString)\(hashtag)") ?? left
        default:
            return URL(string: "\(urlString)?\(query)") ?? left
        }
    }
    public static func +(left: URL, right: [String:String]?) -> URL {
        guard let params = right, params.count > 0 else {
            return left
        }
        return left + params
    }

    public static func +=(left: inout URL, right: [String : String]) {
        left = left + right
    }
    public static func +=(left: inout URL, right: [String : String]?) {
        left = left + right
    }
}

// MARK: Custom Operator for Optional URL
public func +(left: URL?, right: String) -> URL? {
    guard let url = left else {
        return left
    }
    let final = url + right
    return final
}
public func +(left: URL?, right: String?) -> URL? {
    guard let url = left else {
        return left
    }
    let final = url + right
    return final
}

public func +=(left: inout URL?, right: String) {
    left = left + right
}
public func +=(left: inout URL?, right: String?) {
    left = left + right
}

/// Add query params to current url.
public func +(left: URL?, right: [String:String]) -> URL? {
    guard let url = left else {
        return left
    }
    let final = url + right
    return final
}
public func +(left: URL?, right: [String:String]?) -> URL? {
    guard let url = left else {
        return left
    }
    let final = url + right
    return final
}

public func +=(left: inout URL?, right: [String : String]) {
    left = left + right
}
public func +=(left: inout URL?, right: [String : String]?) {
    left = left + right
}
