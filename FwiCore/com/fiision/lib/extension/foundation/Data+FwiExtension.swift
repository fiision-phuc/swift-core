//  Project name: FwiCore
//  File name   : Data+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/22/14
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

    /** Convert data to json */
    public func convertToJson(options otp: JSONSerialization.ReadingOptions = []) -> [String: AnyObject]? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: otp)
            return json as? [String: AnyObject]
        } catch {
            return nil
        }
    }

    /** Convert data to model object */
    @discardableResult
    public func decodeJSONWithModel<T: NSObject>(model m: inout T) -> NSError? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            if let error = FwiJSONMapper.mapObjectToModel(json, model: &m) {
                throw error
            } else {
                return nil
            }

        } catch let error as NSError {
            return error
        }
    }

    /** Convert model object to data */
    @discardableResult
    public func encodeJSONWithModel<T: NSObject>(model m: T) -> NSError? {

        return nil
    }
    
    /** Convert data to string base on string encoding type. */
    public func toString(stringEncoding encoding: String.Encoding = .utf8) -> String? {
        /* Condition validation */
        if count <= 0 {
            return nil
        }
        return String(data: self, encoding: encoding)
    }

    /** Clear all bytes data. */
    public mutating func clearBytes() {
        /* Condition validation */
        if count <= 0 {
            return
        }
        
        let step = count >> 1
        var end = count - 1
        
        for i in 0 ..< step {
            self[end] = 0
            self[i] = 0
            end -= 1
        }

        // Handle the last stand alone byte
        if (count % 2) == 1 {
            self[step] = 0
        }
    }

    /** Reverse the order of bytes. */
    public mutating func reverseBytes() {
        /* Condition validation */
        if count <= 0 {
            return
        }

        let step = count >> 1
        var end = count - 1

        for i in 0 ..< step {
            let temp = self[i]

            self[i] = self[end]
            self[end] = temp
            end -= 1
        }
    }
}

// Open file
public extension Data {
    /** Open file at url */
    public static func openFile(atURL url: URL?, readingMode: Data.ReadingOptions = []) -> Data? {
        guard let url = url, url.isFileURL else {
            return nil
        }
        
        do{
            return try Data(contentsOf: url, options: readingMode)
        }catch {
            return nil
        }
        
    }
    
    @discardableResult
    public func write(toUrl url: URL?, options: Data.WritingOptions = []) -> Error? {
        guard let url = url, url.isFileURL else {
            return NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        }
        
        do {
            try self.write(to: url, options: options)
            return nil
        } catch let error {
            return error
        }
    }
}

// NSCoding
public extension NSCoding {
    /** Using archive to data*/
    public func archiveToData() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    /** Saving object to userdefault*/
    @discardableResult
    public func saveToUserDefault(forKey k: String) -> Bool {
        let userDefault = UserDefaults.standard
        userDefault.set(archiveToData(), forKey: k)
        return userDefault.synchronize()
    }
}


