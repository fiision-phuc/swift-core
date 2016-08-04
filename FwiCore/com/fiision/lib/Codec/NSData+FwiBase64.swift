// Project name: FwiCore
//  File name   : NSData+FwiBase64.swift
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


public extension NSData {

    // MARK: Validate base64
    public func isBase64() -> Bool {
        /* Condition validation */
        if length <= 0 || (length % 4) != 0 {
            return false
        }

        // Load bytes buffer
        let bytes = UnsafePointer<UInt8>(self.bytes)
        let step = self.length >> 1
        var end = self.length - 1

        // Validate each byte
        var isBase64 = true
        for i in 0 ..< step {
            let octet1 = bytes[i]
            let octet2 = bytes[end]

            isBase64 = isBase64 && (octet1 == UTF8.CodeUnit(ascii: "=") || octet1 < UInt8(decodingTable.count))
            isBase64 = isBase64 && (octet2 == UTF8.CodeUnit(ascii: "=") || octet2 < UInt8(decodingTable.count))
            if !isBase64 {
                break
            }
            end -= 1
        }
        return isBase64
    }

    // MARK: Decode base64
    public func decodeBase64Data() -> NSData? {
        /* Condition validation */
        if !isBase64() {
            return nil
        }

        // Initialize buffer
        var b1, b2, b3, b4: UInt8
        let bytes = UnsafePointer<UInt8>(self.bytes)

        // Calculate output length
        let end = length
        let finish = end - 4
        var l = (finish >> 2) * 3

        if bytes[end - 2] == UTF8.CodeUnit(ascii: "=") {
            l += 1
        } else if bytes[end - 1] == UTF8.CodeUnit(ascii: "=") {
            l += 2
        } else {
            l += 3
        }

        // Create output buffer
        var outputBytes = [UInt8](count: l, repeatedValue: 0)

        // Decoding process
        var index = 0
        for i in 0.stride(to: finish, by: 4) {
            b1 = decodingTable[Int(bytes[i])]
            b2 = decodingTable[Int(bytes[i + 1])]
            b3 = decodingTable[Int(bytes[i + 2])]
            b4 = decodingTable[Int(bytes[i + 3])]

            outputBytes[index] = (b1 << 2) | (b2 >> 4)
            outputBytes[index.advancedBy(1)] = (b2 << 4) | (b3 >> 2)
            outputBytes[index.advancedBy(2)] = (b3 << 6) | b4

            index = index.advancedBy(3)
        }

        // Decoding last block process
        if bytes[end - 2] == UTF8.CodeUnit(ascii: "=") {
            b1 = decodingTable[Int(bytes[end - 4])]
            b2 = decodingTable[Int(bytes[end - 3])]

            outputBytes[index] = (b1 << 2) | (b2 >> 4)
        } else if bytes[end - 1] == UTF8.CodeUnit(ascii: "=") {
            b1 = decodingTable[Int(bytes[end - 4])]
            b2 = decodingTable[Int(bytes[end - 3])]
            b3 = decodingTable[Int(bytes[end - 2])]

            outputBytes[index] = (b1 << 2) | (b2 >> 4)
            outputBytes[index.advancedBy(1)] = (b2 << 4) | (b3 >> 2)
        } else {
            b1 = decodingTable[Int(bytes[end - 4])]
            b2 = decodingTable[Int(bytes[end - 3])]
            b3 = decodingTable[Int(bytes[end - 2])]
            b4 = decodingTable[Int(bytes[end - 1])]

            outputBytes[index] = (b1 << 2) | (b2 >> 4)
            outputBytes[index.advancedBy(1)] = (b2 << 4) | (b3 >> 2)
            outputBytes[index.advancedBy(2)] = (b3 << 6) | b4
        }
        return NSData(bytes: outputBytes, length: l)
    }
    public func decodeBase64String() -> String? {
        /* Condition validation */
        if !isBase64() {
            return nil
        }
        return decodeBase64Data()?.toString()
    }

    // MARK: Encode base64
    public func encodeBase64Data() -> NSData? {
        /* Condition validation */
        if length <= 0 {
            return nil
        }

        // Calculate output length
        let modulus = length % 3
        let dataLength = length - modulus
        let outputLength = (dataLength / 3) * 4 + ((modulus == 0) ? 0 : 4)

        // Create output space
        let bytes = UnsafePointer<UInt8>(self.bytes)
        var outputBytes = [UInt8](count: outputLength, repeatedValue: 0)

        // Encoding process
        var index = 0
        var a1, a2, a3: UInt8
        for i in 0.stride(to: dataLength, by: 3) {
            a1 = bytes[i]
            a2 = bytes[i + 1]
            a3 = bytes[i + 2]

            outputBytes[index] = encodingTable[Int((a1 >> 2) & 0x3f)]
            outputBytes[index.advancedBy(1)] = encodingTable[Int(((a1 << 4) | (a2 >> 4)) & 0x3f)]
            outputBytes[index.advancedBy(2)] = encodingTable[Int(((a2 << 2) | (a3 >> 6)) & 0x3f)]
            outputBytes[index.advancedBy(3)] = encodingTable[Int(a3 & 0x3f)]

            index = index.advancedBy(4)
        }

        // Process the tail end
        var b1, b2, b3: UInt8
        var d1, d2: UInt8
        switch modulus {
        case 1:
            d1 = bytes[dataLength]
            b1 = (d1 >> 2) & 0x3f
            b2 = (d1 << 4) & 0x3f

            outputBytes[index] = encodingTable[Int(b1)]
            outputBytes[index.advancedBy(1)] = encodingTable[Int(b1)]
            outputBytes[index.advancedBy(2)] = UTF8.CodeUnit(ascii: "=")
            outputBytes[index.advancedBy(3)] = UTF8.CodeUnit(ascii: "=")
            break

        case 2:
            d1 = bytes[dataLength]
            d2 = bytes[dataLength + 1]

            b1 = (d1 >> 2) & 0x3f
            b2 = ((d1 << 4) | (d2 >> 4)) & 0x3f
            b3 = (d2 << 2) & 0x3f

            outputBytes[index] = encodingTable[Int(b1)]
            outputBytes[index.advancedBy(1)] = encodingTable[Int(b2)]
            outputBytes[index.advancedBy(2)] = encodingTable[Int(b3)]
            outputBytes[index.advancedBy(3)] = UTF8.CodeUnit(ascii: "=")
            break

        default:
            break
        }
        return NSData(bytes: outputBytes, length: outputLength)
    }
    public func encodeBase64String() -> String? {
        /* Condition validation */
        if length <= 0 {
            return nil
        }
        return self.encodeBase64Data()?.toString()
    }
}


// MARK: Lookup table
private let encodingTable: [UInt8] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".utf8)
private let decodingTable: [UInt8] = [
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x00, 0x00, 0x3f,
    0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
    0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28,
    0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00]
