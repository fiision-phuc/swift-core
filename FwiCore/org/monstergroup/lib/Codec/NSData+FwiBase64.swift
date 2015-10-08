//  Project name: FwiCore
//  File name   : NSData+FwiBase64.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/20/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
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
//  testing. Monster Group  disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import Foundation


let base64EncodingTable: [UInt8] = [0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x2B,0x2F]
let base64DecodingTable: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3e,0x00,0x00,0x00,0x3f,0x34,0x35,0x36,0x37,0x38,0x39,0x3a,0x3b,0x3c,0x3d,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x00,0x00,0x00,0x00,0x00,0x00,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f,0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2a,0x2b,0x2c,0x2d,0x2e,0x2f,0x30,0x31,0x32,0x33,0x00,0x00,0x00,0x00,0x00]


public extension NSData {
    
    // MARK: Validate base64
    public func isBase64() -> Bool {
        /* Condition validation */
        if (self.length <= 0 || (self.length % 4) != 0) {
            return false
        }
        
        // Load bytes buffer
        var bytes = UnsafePointer<UInt8>(self.bytes)
        var step  = self.length >> 1
        var end   = self.length - 1
        
        // Validate each byte
        var isBase64 = true
        for (var i = 0; i < step; i++, end--) {
            var octet1 = bytes[i]
            var octet2 = bytes[end]

            isBase64 = isBase64 && (octet1 == UTF8.CodeUnit(ascii: "=") || octet1 < UInt8(count(base64DecodingTable)))
            isBase64 = isBase64 && (octet2 == UTF8.CodeUnit(ascii: "=") || octet2 < UInt8(count(base64DecodingTable)))
            if (!isBase64) {
                break
            }
        }
        return isBase64
    }
    
    
    // MARK: Decode base64
    public func decodeBase64Data() -> NSData? {
        /* Condition validation */
        if !self.isBase64() {
            println("[FwiBase64] Decode Error: Invalid base64.")
            return nil
        }
        
        // Initialize buffer
        var b1: UInt8, b2: UInt8, b3: UInt8, b4: UInt8
        var bytes = UnsafePointer<UInt8>(self.bytes)
        
        // Calculate output length
        var end = self.length
        var finish = end - 4
        var length = (finish >> 2) * 3
        
        if (bytes[end - 2] == UTF8.CodeUnit(ascii: "=")) {
            length += 1
        }
        else if (bytes[end - 1] == UTF8.CodeUnit(ascii: "=")) {
            length += 2
        }
        else {
            length += 3
        }
        
        // Create output buffer
        var outputBytes = [UInt8](count: length, repeatedValue: 0)
        
        // Decoding process
        var index = -1
        for (var i = 0; i < finish; i += 4) {
            b1 = base64DecodingTable[Int(bytes[i])]
            b2 = base64DecodingTable[Int(bytes[i + 1])]
            b3 = base64DecodingTable[Int(bytes[i + 2])]
            b4 = base64DecodingTable[Int(bytes[i + 3])]
            
            outputBytes[++index] = (b1 << 2) | (b2 >> 4)
            outputBytes[++index] = (b2 << 4) | (b3 >> 2)
            outputBytes[++index] = (b3 << 6) | b4
        }
        
        // Decoding last block process
        if (bytes[end - 2] == UTF8.CodeUnit(ascii: "=")) {
            b1 = base64DecodingTable[Int(bytes[end - 4])]
            b2 = base64DecodingTable[Int(bytes[end - 3])]
            
            outputBytes[++index] = (b1 << 2) | (b2 >> 4)
        }
        else if (bytes[end - 1] == UTF8.CodeUnit(ascii: "=")) {
            b1 = base64DecodingTable[Int(bytes[end - 4])]
            b2 = base64DecodingTable[Int(bytes[end - 3])]
            b3 = base64DecodingTable[Int(bytes[end - 2])]
            
            outputBytes[++index] = (b1 << 2) | (b2 >> 4)
            outputBytes[++index] = (b2 << 4) | (b3 >> 2)
        }
        else {
            b1 = base64DecodingTable[Int(bytes[end - 4])]
            b2 = base64DecodingTable[Int(bytes[end - 3])]
            b3 = base64DecodingTable[Int(bytes[end - 2])]
            b4 = base64DecodingTable[Int(bytes[end - 1])]
            
            outputBytes[++index] = (b1 << 2) | (b2 >> 4)
            outputBytes[++index] = (b2 << 4) | (b3 >> 2)
            outputBytes[++index] = (b3 << 6) | b4
        }
        return NSData(bytes: outputBytes, length: length)
    }
    public func decodeBase64String() -> String? {
        /* Condition validation */
        if (!self.isBase64()) {
            println("[FwiBase64] Decode Error: Invalid base64.")
            return nil
        }
        return self.decodeBase64Data()?.toString()
    }
    
    
    // MARK: Encode base64
    public func encodeBase64Data() -> NSData? {
        /* Condition validation */
        if (self.length <= 0) {
            println("[FwiBase64] Encode Error: Data length must be greater than zero.")
            return nil
        }
        
        // Calculate output length
        var modulus = self.length % 3
        var dataLength = self.length - modulus
        var outputLength = (dataLength / 3) * 4 + ((modulus == 0) ? 0 : 4)
        
        // Create output space
        var bytes = UnsafePointer<UInt8>(self.bytes)
        var outputBytes = [UInt8](count: outputLength, repeatedValue: 0)
        
        // Encoding process
        var index = -1
        var a1: UInt8, a2: UInt8, a3: UInt8
        for (var i = 0; i < dataLength; i += 3) {
            a1 = bytes[i]
            a2 = bytes[i + 1]
            a3 = bytes[i + 2]

            outputBytes[++index] = base64EncodingTable[Int((a1 >> 2) & 0x3f)]
            outputBytes[++index] = base64EncodingTable[Int(((a1 << 4) | (a2 >> 4)) & 0x3f)]
            outputBytes[++index] = base64EncodingTable[Int(((a2 << 2) | (a3 >> 6)) & 0x3f)]
            outputBytes[++index] = base64EncodingTable[Int(a3 & 0x3f)]
        }
        
        // Process the tail end
        var b1: UInt8, b2: UInt8, b3: UInt8
        var d1: UInt8, d2: UInt8
        switch (modulus) {
        case 1:
            d1 = bytes[dataLength]
            b1 = (d1 >> 2) & 0x3f
            b2 = (d1 << 4) & 0x3f
            
            outputBytes[++index] = base64EncodingTable[Int(b1)]
            outputBytes[++index] = base64EncodingTable[Int(b1)]
            outputBytes[++index] = UTF8.CodeUnit(ascii: "=")
            outputBytes[++index] = UTF8.CodeUnit(ascii: "=")
            break

        case 2:
            d1 = bytes[dataLength]
            d2 = bytes[dataLength + 1]
            
            b1 = (d1 >> 2) & 0x3f
            b2 = ((d1 << 4) | (d2 >> 4)) & 0x3f
            b3 = (d2 << 2) & 0x3f
            
            outputBytes[++index] = base64EncodingTable[Int(b1)]
            outputBytes[++index] = base64EncodingTable[Int(b2)]
            outputBytes[++index] = base64EncodingTable[Int(b3)]
            outputBytes[++index] = UTF8.CodeUnit(ascii: "=")
            break

        default:
            break
        }
        return NSData(bytes: outputBytes, length: outputLength)
    }
    public func encodeBase64String() -> String? {
        /* Condition validation */
        if (self.length <= 0) {
            println("[FwiBase64] Encode Error: Data length must be greater than zero.")
            return nil
        }
        return self.encodeBase64Data()?.toString()
    }
}