//  Project name: FwiCore
//  File name   : FwiMultipartParam.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/3/14
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


public struct FwiMultipartParam: CustomDebugStringConvertible, CustomStringConvertible {

    // MARK: Struct's constructors
    public init(name: String = "", fileName file: String = "", contentData data: Data = Data(), contentType type: String = "") {
        self.name = name
        self.fileName = file
        self.contentData = data
        self.contentType = type
    }

    // MARK: Struct's properties
    public fileprivate (set) var name: String
    public fileprivate (set) var fileName: String
    public fileprivate (set) var contentData: Data
    public fileprivate (set) var contentType: String

    // MARK: Struct's private methods
    fileprivate var hashValue: Int {
        var hash = name.hashValue
        hash ^= fileName.hashValue
        hash ^= contentData.hashValue
        hash ^= contentType.hashValue
        return hash
    }

    // MARK: CustomDebugStringConvertible's members
    public var debugDescription: String {
        return description
    }

    // MARK: CustomStringConvertible's members
    public var description: String {
        let type = "Content-Type: \(contentType)"
        let disposition = "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"

        if let encoded = contentData.encodeBase64String() {
            return "\n\(type)\n\(disposition)\n\(encoded)"
        }
        return "\n\(type)\n\(disposition)"
    }
}

// MARK: Custom Operator
public func == (left: FwiMultipartParam, right: FwiMultipartParam?) -> Bool {
    return left.hashValue == right?.hashValue
}
