//  File name   : NSData+FwiBase64.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/20/14
//  --------------------------------------------------------------
//  Copyright © 2012, 2018 Fiision Studio. All Rights Reserved.
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

public extension Data {
    // MARK: Validate base64

    public var isBase64: Bool {
        /* Condition validation */
        if count <= 0 || (count % 4) != 0 {
            return false
        }

        var isBase64 = true
        withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
            var p1 = pointer
            var p2 = pointer.advanced(by: (count - 1))

            let step = count >> 2
            for _ in 0...step {
                let v1 = p1.pointee
                let v2 = p2.pointee

                // Check v1
                isBase64 = isBase64 && ((48 <= v1 && v1 <= 57) || // '0-9'
                    (65 <= v1 && v1 <= 90) || // 'A-Z'
                    (97 <= v1 && v1 <= 122) || // 'a-z'
                    v1 == 9 || // '\t'
                    v1 == 10 || // '\n'
                    v1 == 13 || // '\r'
                    v1 == 32 || // ' '
                    v1 == 43 || // '+'
                    v1 == 47 || // '/'
                    v1 == 61) // '='

                // Check v2
                isBase64 = isBase64 && ((48 <= v2 && v2 <= 57) || // '0-9'
                    (65 <= v2 && v2 <= 90) || // 'A-Z'
                    (97 <= v2 && v2 <= 122) || // 'a-z'
                    v2 == 9 || // '\t'
                    v2 == 10 || // '\n'
                    v2 == 13 || // '\r'
                    v2 == 32 || // ' '
                    v2 == 43 || // '+'
                    v2 == 47 || // '/'
                    v2 == 61) // '='

                if isBase64 {
                    p1 = p1.advanced(by: 1)
                    p2 = p2.advanced(by: -1)
                } else {
                    break
                }
            }
        }
        return isBase64
    }

    // MARK: Decode base64

    public func decodeBase64Data() -> Data? {
        return isBase64 ? Data(base64Encoded: self, options: .ignoreUnknownCharacters) : nil
    }

    public func decodeBase64String() -> String? {
        return decodeBase64Data()?.toString()
    }

    // MARK: Encode base64

    public func encodeBase64Data() -> Data? {
        return count > 0 ? base64EncodedData(options: .endLineWithCarriageReturn) : nil
    }

    public func encodeBase64String() -> String? {
        return self.encodeBase64Data()?.toString()
    }
}
