//  Project name: FwiCore
//  File name   : URL+FwiExtension.swift
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


public extension URL {

    /** URL to main cache folder. */
    public static func cacheDirectory() -> URL? {
        let array = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return array.first
    }

    /** URL to main document folder. */
    public static func documentDirectory() -> URL? {
        let array = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return array.first
    }
    
    public func addHashTag(with hashTag: String?) -> URL? {
        return URL(string: "\(self)" + (hashTag ?? ""))
    }
}

// MARK: Custom Operator
public func + (left: URL?, right: String?) -> URL? {
    guard let path = right else {
        return left
    }
    
    if left?.absoluteString.hasSuffix("/") == true && path.hasPrefix("/") {
        return left?.appendingPathComponent(path.substring(startIndex: 1))
    }
    return left?.appendingPathComponent(path)
}
public func += (left: inout URL?, right: String?) {
    left = left + right
}

public func + (left: URL?, right: [String: String]?) -> URL? {
    guard let url = left, (right?.count ?? 0) > 0 else {
        return left
    }
    
    // Convert to form
    let forms = right?.map({ FwiFormParam(key: $0, value: $1) })
    
    // filter tag
    let hashtag = forms?.filter({ $0.key[0] == "#"}).sorted(by: <).first?.description ?? ""
    
    // Query
    let query = forms?.filter({ $0.key[0] != "#"}).sorted(by: <).map({ $0.description }).joined(separator: "&") ?? ""
 
    return query.characters.count > 0 ? URL(string: "\(url)\(hashtag)?\(query)") : URL(string: "\(url)\(hashtag)")
}

public func += (left: inout URL?, right: [String:String]?) {
    left = left + right
}
