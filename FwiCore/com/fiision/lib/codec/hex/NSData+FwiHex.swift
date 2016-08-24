//  Project name: FwiCore
//  File name   : NSData+FwiHex.swift
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

        // Load bytes buffer
        let bytes = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)
        let step = count >> 1
        var end = count - 1

        // Validate each byte
        var isHex = true
        for i in 0..<step {
            let hex1 = bytes[i]
            let hex2 = bytes[end]

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

        let l = count >> 1
        var outputBytes = [UInt8](repeating: 0, count: l)
        return self.withUnsafeBytes { (chars: UnsafePointer<UInt8>) -> Data in
            for i in stride(from: 0, to: l, by: 2) {
                let b1 = chars[i]
                let b2 = chars[i + 1]
                
                outputBytes[i / 2] = ((decodingTable[Int(b1)] << 4) | decodingTable[Int(b2)])
            }
            return Data(bytes: UnsafePointer<UInt8>(outputBytes), count: l)
        }
      
    }
    public func decodeHexString() -> String? {
        /* Condition validation */
        if !isHex() {
            return nil
        }
        return decodeHexData()?.toString()
    }

    // MARK: Encode Hex
    public func encodeHexData() -> Data? {
        /* Condition validation */
        if count <= 0 {
            return nil
        }

        let l = count << 1
        var outputBytes = [UInt8](repeating: 0, count: l)

        var j = 0
        let bytes = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)
        for i in stride(from: 0, to: l, by: 2) {
            let b = bytes[j]
            outputBytes[i] = encodingTable[Int(b >> 4)]
            outputBytes[i + 1] = encodingTable[Int(b & 0x0f)]

            j += 1
        }
        return Data(bytes: UnsafePointer<UInt8>(outputBytes), count: l)
    }
    public func encodeHexString() -> String? {
        /* Condition validation */
        if count <= 0 {
            return nil
        }
        return encodeHexData()?.toString()
    }
}


// MARK: Lookup table
private let encodingTable: [UInt8] = Array("0123456789abcdef".utf8)
private let decodingTable: [UInt8] = [
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
