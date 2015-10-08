//  Project name: FwiCore
//  File name   : NSData+FwiHex.swift
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


let hexEncodingTable: [UInt8] = [0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x61,0x62,0x63,0x64,0x65,0x66]
let hexDecodingTable: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]


public extension NSData {
   
    // MARK: Validate Hex
    public func isHex() -> Bool {
        /* Condition validation */
        if (self.length <= 0 || (self.length % 2) != 0) {
            return false
        }
        
        // Load bytes buffer
        var bytes = UnsafePointer<UInt8>(self.bytes)
        var step  = self.length >> 1
        var end   = self.length - 1
            
        // Validate each byte
        var isHex = true
        for (var i = 0; i < step; i++, end--) {
            var hex1 = bytes[i]
            var hex2 = bytes[end]
            
            isHex = isHex && (hex1 >= 0 || hex1 < UInt8(count(hexDecodingTable)))
            isHex = isHex && (hex2 >= 0 || hex2 < UInt8(count(hexDecodingTable)))
            if (!isHex) {
                break
            }
        }
        return isHex
    }
    
    
    // MARK: Decode Hex
    public func decodeHexData() -> NSData? {
        /* Condition validation */
        if (!self.isHex()) {
            return nil
        }
        
        var length = self.length >> 1
        var outputBytes = [UInt8](count: length, repeatedValue: 0)
        
        var chars = UnsafePointer<UInt8>(self.bytes)
        for (var i = 0; i < self.length; i += 2) {
            var b1 = chars[i]
            var b2 = chars[i + 1]
            
            outputBytes[i / 2] = ((hexDecodingTable[Int(b1)] << 4) | hexDecodingTable[Int(b2)])
        }
        return NSData(bytes: outputBytes, length: length)
    }
    public func decodeHexString() -> String? {
        /* Condition validation */
        if (!self.isHex()) {
            return nil
        }
        return self.decodeHexData()?.toString()
    }
    
    
    // MARK: Encode Hex
    public func encodeHexData() -> NSData? {
        /* Condition validation */
        if (self.length <= 0) {
            return nil
        }
        
        var length = self.length << 1
        var outputBytes = [UInt8](count: length, repeatedValue: 0)
        
        var bytes = UnsafePointer<UInt8>(self.bytes)
        for (var i = 0, j = 0; i < length; i += 2, j++) {
            var b = bytes[j]
            outputBytes[i] = hexEncodingTable[Int(b >> 4)]
            outputBytes[i + 1] = hexEncodingTable[Int(b & 0x0f)]
        }
        return NSData(bytes: outputBytes, length: length)
    }
    public func encodeHexString() -> String? {
        /* Condition validation */
        if (self.length <= 0) {
            return nil
        }
        return self.encodeHexData()?.toString()
    }
}