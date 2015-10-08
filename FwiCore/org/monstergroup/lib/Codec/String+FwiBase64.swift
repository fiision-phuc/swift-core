//  Project name: FwiCore
//  File name   : String+FwiBase64.swift
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


public extension String {
    
    // MARK: Validate base64
    public func isBase64() -> Bool {
        /* Condition validation */
        if (count(self) <= 0) {
            return false
        }
        
        var data = self.toData()
        return (data != nil ? self.toData()!.isBase64() : false)
    }
    
    
    // MARK: Decode base64
    public func decodeBase64Data() -> NSData? {
        /* Condition validation */
        if (count(self) <= 0) {
            println("[FwiBase64] Decode Error: Invalid base64 string length.")
            return nil
        }
        
        var data = self.toData()
        return data?.decodeBase64Data()
    }
    public func decodeBase64String() -> String? {
        /* Condition validation */
        if (count(self) <= 0) {
            println("[FwiBase64] Decode Error: Invalid base64 string length.")
            return nil
        }
        
        var data = self.toData()
        return data?.decodeBase64String()
    }
    
    
    // MARK: Encode base64
    public func encodeBase64Data() -> NSData? {
        /* Condition validation */
        if (count(self) <= 0) {
            println("[FwiBase64] Encode Error: String length must be greater than zero.")
            return nil
        }
        
        var data = self.toData()
        return data?.encodeBase64Data()
    }
    public func encodeBase64String() -> String? {
        /* Condition validation */
        if (count(self) <= 0) {
            println("[FwiBase64] Encode Error: String length must be greater than zero.")
            return nil
        }
        
        var data = self.toData()
        return data?.encodeBase64String()
    }
}