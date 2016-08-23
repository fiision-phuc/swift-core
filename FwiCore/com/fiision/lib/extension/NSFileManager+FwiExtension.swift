//  Project name: FwiCore
//  File name   : NSFileManager+FwiExtension.swift
//
//  Author      : Dung Vu
//  Created date: 6/8/16
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


extension FileManager {

    /** Check if file is available for a given URL. */
    func fileExistsAtURL(_ url: URL?) -> Bool {
        guard let url = url, let path = url.path else {
            return false
        }
        return self.fileExists(atPath: path)
    }

    /** Delete file for a given URL. */
    func deleteFileAtURL(_ url: URL?) {
        guard let u = url , self.fileExistsAtURL(url) else {
            return
        }

        do {
            try self.removeItem(at: u)
        } catch _ {
            // Do nothing
        }
    }

    /**
     Create Directory From NSURL

     - parameter url:            path where you want create
     - parameter intermediate: it'll decide override to directory if exist
     - parameter attributes:     create attribute

     - returns: error if it has
     */
    func createDirectoryAtURL(_ url: URL?, withIntermediateDirectories intermediate: Bool, attributes: [String: AnyObject]? = nil) -> NSError? {
        guard let url = url , url.path != nil else {
            return NSError(domain: NSURLErrorKey, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "URL Not Exist!!!"])
        }
        do {
            try self.createDirectory(at: url, withIntermediateDirectories: intermediate, attributes: attributes)
            return nil
        } catch let error as NSError {
            return error
        }
    }
    /**
     Move Item

     - parameter fUrl: source Url
     - parameter tURl: to Url

     - returns: error if it has
     */
    func moveItem(from fUrl: URL?, to tURl: URL?) -> NSError? {
        guard let fUrl = fUrl, let tURl = tURl else {
            return NSError(domain: NSURLErrorKey, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "URL Not Exist!!!"])
        }
        do {
            try self.moveItem(at: fUrl, to: tURl)
            return nil
        } catch let error as NSError {
            return error
        }
    }
}

extension URL {
    /**
     Check Url is directory

     - returns: true/ false
     */
    func isDirectory() -> Bool {
        guard self.path != nil else { return false }
        do {
            var rsrc: AnyObject?
            try (self as NSURL).getResourceValue(&rsrc, forKey: URLResourceKey.isDirectoryKey)
            if let isDirectory = rsrc as? NSNumber , isDirectory == true {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
