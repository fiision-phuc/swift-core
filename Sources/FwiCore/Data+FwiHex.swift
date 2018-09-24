//  File name   : Data+FwiHex.swift
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
    // MARK: Validate Hex

    public var isHex: Bool {
        /* Condition validation */
        if count <= 0 || (count % 2) != 0 {
            return false
        }

        var isHex = true
        withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
            var p1 = pointer
            var p2 = pointer.advanced(by: (count - 1))

            let step = count >> 2
            for _ in 0...step {
                let v1 = p1.pointee
                let v2 = p2.pointee

                // Check v1
                isHex = isHex && ((48 <= v1 && v1 <= 57) || // '0-9'
                    (65 <= v1 && v1 <= 70) || // 'A-F'
                    (97 <= v1 && v1 <= 102)) // 'a-f'

                // Check v2
                isHex = isHex && ((48 <= v2 && v2 <= 57) || // '0-9'
                    (65 <= v2 && v2 <= 70) || // 'A-F'
                    (97 <= v2 && v2 <= 102)) // 'a-f'

                if isHex {
                    p1 = p1.advanced(by: 1)
                    p2 = p2.advanced(by: -1)
                } else {
                    break
                }
            }
        }
        return isHex
    }

    // MARK: Decode Hex

    public func decodeHexData() -> Data? {
        /* Condition validation */
        if !isHex {
            return nil
        }

        var output = [UInt8](repeating: 0, count: (count >> 1))
        for i in stride(from: 0, to: count, by: 2) {
            var b1 = self[i]
            var b2 = self[i + 1]

            if 48 <= b1 && b1 <= 57 { // '0-9'
                b1 -= 48
            } else if 65 <= b1 && b1 <= 70 { // 'A-F'
                b1 -= 55 // A = 10, 'A' = 65 -> b = 65 - 55
            } else { // 'a-f'
                b1 -= 87 // a = 10, 'a' = 97 -> b = 97 - 87
            }

            if 48 <= b2 && b2 <= 57 { // '0-9'
                b2 -= 48
            } else if 65 <= b2 && b2 <= 70 { // 'A-F'
                b2 -= 55 // A = 10, 'A' = 65 -> b = 65 - 55
            } else { // 'a-f'
                b2 -= 87 // a = 10, 'a' = 97 -> b = 97 - 87
            }

            output[i / 2] = (b1 << 4 | b2)
        }
        return Data(bytes: output)
    }

    public func decodeHexString() -> String? {
        return decodeHexData()?.toString()
    }

    // MARK: Encode Hex

    public func encodeHexData() -> Data? {
        /* Condition validation */
        if count <= 0 {
            return nil
        }

        var j = 0
        let l = count << 1
        var output = [UInt8](repeatElement(0, count: l))

        for i in stride(from: 0, to: l, by: 2) {
            let b = self[j]
            j += 1

            var v1 = (b & 0xf0) >> 4
            var v2 = b & 0x0f

            if 0 <= v1 && v1 <= 9 { // '0-9'
                v1 += 48
            } else { // 'a-f'
                v1 += 87 // a = 10, 'a' = 97 -> b = 10 + 87
            }

            if 0 <= v2 && v2 <= 9 { // '0-9'
                v2 += 48
            } else { // 'a-f'
                v2 += 87 // a = 10, 'a' = 97 -> b = 10 + 87
            }

            output[i] = v1
            output[i + 1] = v2
        }
        return Data(bytes: output)
    }

    public func encodeHexString() -> String? {
        return encodeHexData()?.toString()
    }
}
