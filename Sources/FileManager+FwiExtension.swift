//  Project name: FwiCore
//  File name   : FileManager+FwiExtension.swift
//
//  Author      : Dung Vu
//  Created date: 6/8/16
//  Version     : 2.0.0
//  --------------------------------------------------------------
//  Copyright © 2012, 2017 Fiision Studio.
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


public extension FileManager {
    
    // MARK: Directory manager
    /// Create directory for a given URL.
    ///
    /// - parameter url (required): destination url to create directory
    /// - parameter intermediateDirectories (optional): should create intermediate directories as well
    @discardableResult
    public func createDirectory(atURL url: URL?, withIntermediateDirectories intermediate: Bool = true, attributes: [FileAttributeKey: Any]? = nil) -> Error? {
        guard let url = url, url.isFileURL && url != URL.documentDirectory() && url != URL.cacheDirectory() else {
            return NSError(domain: NSURLErrorKey, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "Invalid directory's URL."])
        }
        
        do {
            try createDirectory(at: url, withIntermediateDirectories: intermediate, attributes: attributes)
            return nil
        } catch let err as NSError {
            return err
        }
    }
    
    /// Check if directory is available for a given URL.
    ///
    /// - parameter url (required): destination url
    public func directoryExists(atURL url: URL?) -> Bool {
        guard let path = url?.path else {
            return false
        }
        
        var isDirectory: ObjCBool = false
        let isExist = fileExists(atPath: path, isDirectory: &isDirectory)
        return isExist && isDirectory.boolValue
    }

    /// Move directory from source's URL to destination's URL.
    ///
    /// - parameter from (required): source url
    /// - parameter to (required): destination url
    @discardableResult
    public func moveDirectory(from srcURL: URL?, to dstURL: URL?) -> Error? {
        return moveFile(from: srcURL, to: dstURL)
    }

    /// Remove directory for a given URL.
    ///
    /// - parameter url (required): source url
    @discardableResult
    public func removeDirectory(atURL url: URL?) -> Error? {
        return removeFile(atURL: url)
    }
    
    // MARK: File manager
    /// Check if file is available for a given URL.
    ///
    /// - parameter url (required): source url
    public func fileExists(atURL url: URL?) -> Bool {
        guard let path = url?.path else {
            return false
        }
        return fileExists(atPath: path)
    }
    
    /// Move file from source's URL to destination's URL.
    ///
    /// - parameter from (required): source url
    /// - parameter to (required): destination url
    @discardableResult
    public func moveFile(from srcURL: URL?, to dstURL: URL?) -> Error? {
        guard let srcURL = srcURL, let dstURL = dstURL else {
            return NSError(domain: NSURLErrorKey, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "Invalid file's source's URL or destination's URL."])
        }
        
        do {
            try moveItem(at: srcURL, to: dstURL)
            return nil
        } catch let err as NSError {
            return err
        }
    }
    
    /// Remove file for a given URL.
    ///
    /// - parameter url (required): source url
    @discardableResult
    public func removeFile(atURL url: URL?) -> Error? {
        guard let url = url , fileExists(atURL: url) else {
            return NSError(domain: NSURLErrorKey, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "Invalid file's URL."])
        }
        
        do {
            try removeItem(at: url)
            return nil
        } catch let err as NSError {
            return err
        }
    }
}

