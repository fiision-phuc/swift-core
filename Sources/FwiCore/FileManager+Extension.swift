//  File name   : FileManager+Extension.swift
//
//  Author      : Dung Vu
//  Created date: 6/8/16
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

// MARK: Directory manager
public extension FileManager {
    /// Create directory for a given URL.
    ///
    /// - parameter url (required): destination url to create directory
    /// - parameter intermediateDirectories (optional): should create intermediate directories as well
    func createDirectory(_ atURL: URL?, intermediateDirectories: Bool = true, attributes: [FileAttributeKey: Any]? = nil) throws {
        guard let url = atURL, url.isFileURL, url != URL.documentDirectory(), url != URL.cacheDirectory() else {
            let info = [NSLocalizedDescriptionKey: "Invalid directory's URL."]
            throw NSError(domain: NSURLErrorKey, code: NSURLErrorBadURL, userInfo: info)
        }
        try createDirectory(at: url, withIntermediateDirectories: intermediateDirectories, attributes: attributes)
    }

    /// Check if directory is available for a given URL.
    ///
    /// - parameter url (required): destination url
    func directoryExists(_ atURL: URL?) -> Bool {
        guard let path = atURL?.path else {
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
    func moveDirectory(_ from: URL?, to: URL?) throws {
        return try moveFile(from, to: to)
    }

    /// Remove directory for a given URL.
    ///
    /// - parameter url (required): source url
    func removeDirectory(_ atURL: URL?) throws {
        return try removeFile(atURL)
    }
}

// MARK: File manager
public extension FileManager {
    /// Check if file is available for a given URL.
    ///
    /// - parameter url (required): source url
    func fileExists(_ atURL: URL?) -> Bool {
        guard let path = atURL?.path else {
            return false
        }
        return fileExists(atPath: path)
    }

    /// Move file from source's URL to destination's URL.
    ///
    /// - parameter from (required): source url
    /// - parameter to (required): destination url
    func moveFile(_ from: URL?, to: URL?) throws {
        guard let srcURL = from, let dstURL = to else {
            let info = [NSLocalizedDescriptionKey: "Invalid file's source's URL or destination's URL."]
            throw NSError(domain: NSURLErrorKey, code: NSURLErrorBadURL, userInfo: info)
        }
        try moveItem(at: srcURL, to: dstURL)
    }

    /// Remove file for a given URL.
    ///
    /// - parameter url (required): source url
    func removeFile(_ atURL: URL?) throws {
        guard let url = atURL, fileExists(url) else {
            throw NSError(domain: NSURLErrorKey, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "Invalid file's URL."])
        }
        try removeItem(at: url)
    }
}
