//  File name   : NSData+Base64.swift
//
//  Author      : Phuc, Tran Huu
//  Editor      : Dung Vu
//  Created date: 11/20/14
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

public extension Data {
    // MARK: - Validate base64
    var isBase64: Bool {
        /* Condition validation */
        if count <= 0 || (count % 4) != 0 { return false }
        var isBase64 = true

        let input = [UInt8](self)
        for index in stride(from: 0, to: count, by: 2) {
            let b1 = input[index]
            let b2 = input[index + 1]

            // Check v1
            isBase64 = isBase64 && ((b1 >= 48 && b1 <= 57) || // '0-9'
                (b1 >= 65 && b1 <= 90) || // 'A-Z'
                (b1 >= 97 && b1 <= 122) || // 'a-z'
                b1 == 9 || // '\t'
                b1 == 10 || // '\n'
                b1 == 13 || // '\r'
                b1 == 32 || // ' '
                b1 == 43 || // '+'
                b1 == 47 || // '/'
                b1 == 61) // '='

            // Check v2
            isBase64 = isBase64 && ((b2 >= 48 && b2 <= 57) || // '0-9'
                (b2 >= 65 && b2 <= 90) || // 'A-Z'
                (b2 >= 97 && b2 <= 122) || // 'a-z'
                b2 == 9 || // '\t'
                b2 == 10 || // '\n'
                b2 == 13 || // '\r'
                b2 == 32 || // ' '
                b2 == 43 || // '+'
                b2 == 47 || // '/'
                b2 == 61) // '='

            if !isBase64 { break }
        }
        return isBase64
    }

    // MARK: - Decode base64
    func decodeBase64Data() -> Data? { isBase64 ? Data(base64Encoded: self, options: .ignoreUnknownCharacters) : nil }

    func decodeBase64String() -> String? { decodeBase64Data()?.toString() }

    // MARK: - Encode base64
    func encodeBase64Data() -> Data? { count > 0 ? base64EncodedData(options: .endLineWithCarriageReturn) : nil }

    func encodeBase64String() -> String? { self.encodeBase64Data()?.toString() }
}
