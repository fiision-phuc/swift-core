//  Project name: FwiCore
//  File name   : Data+FwiHex.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/20/14
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


public extension Data {

    // MARK: Validate Hex
    public func isHex() -> Bool {
        /* Condition validation */
        if count <= 0 || (count % 2) != 0 {
            return false
        }

        let step = count >> 1
        var end = count - 1

        // Validate each byte
        var isHex = true
        for i in 0 ..< step {
            let hex1 = self[i]
            let hex2 = self[end]

            isHex = isHex && (hex1 >= 0 || hex1 < UInt8(decodingTable.count))
            isHex = isHex && (hex2 >= 0 || hex2 < UInt8(decodingTable.count))
            if !isHex {
                break
            }
            end -= 1
        }
        return isHex
    }

    // MARK: Decode Hex
    public func decodeHexData() -> Data? {
        /* Condition validation */
        if !isHex() {
            return nil
        }

        var output = [UInt8](repeating:0, count: (count >> 1))
        for i in stride(from: 0, to: count, by: 2) {
            let b1 = self[i]
            let b2 = self[i + 1]
            output[i / 2] = ((decodingTable[Int(b1)] << 4) | decodingTable[Int(b2)])
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

            output[i] = encodingTable[Int(b >> 4)]
            output[i + 1] = encodingTable[Int(b & 0x0f)]
        }
        return Data(bytes: output)
    }
    public func encodeHexString() -> String? {
        return encodeHexData()?.toString()
    }
}


// MARK: Lookup table
fileprivate let encodingTable: [UInt8] = Array("0123456789abcdef".utf8)
fileprivate let decodingTable: [UInt8] = [
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
]
