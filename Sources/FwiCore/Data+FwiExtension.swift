//  File name   : Data+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/22/14
//  --------------------------------------------------------------
//  Copyright © 2012, 2018 Fiision Studio. All Rights Reserved.
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
    /// Return raw data.
    public func bytes() -> [UInt8] {
        guard count > 0 else {
            return []
        }
        var bytes = [UInt8](repeating: 0, count: count)

        copyBytes(to: &bytes, from: Range<Data.Index>(uncheckedBounds: (lower: 0, upper: count)))
        return bytes
    }

    /// Clear all bytes data.
    public mutating func clearBytes() {
        /* Condition validation */
        if count <= 0 {
            return
        }

        let step = count >> 1
        var end = count - 1

        for i in 0..<step {
            self[end] = 0
            self[i] = 0
            end -= 1
        }

        // Handle the last stand alone byte
        if (count % 2) == 1 {
            self[step] = 0
        }
    }

    /// Reverse the order of bytes.
    public mutating func reverseBytes() {
        /* Condition validation */
        if count <= 0 {
            return
        }

        let step = count >> 1
        var end = count - 1

        for i in 0..<step {
            let temp = self[i]

            self[i] = self[end]
            self[end] = temp
            end -= 1
        }
    }

    /// Convert data to string base on string encoding type.
    ///
    /// - parameter stringEncoding (optional): string encoding, default is UTF-8
    public func toString(stringEncoding encoding: String.Encoding = .utf8) -> String? {
        /* Condition validation */
        if count <= 0 {
            return nil
        }
        return String(data: self, encoding: encoding)
    }

    // MARK: File I/O
    /// Read data from file.
    ///
    /// - parameter url (required): source url to read from
    /// - parameter readingMode (optional): seealso `Data.ReadingOptions`
    public static func read(fromFile url: URL?, readingMode mode: Data.ReadingOptions = []) -> Data? {
        guard let url = url, url.isFileURL else {
            return nil
        }
        return try? Data(contentsOf: url, options: mode)
    }

    /// Write data to file.
    ///
    /// - parameter url (required): destination url to write to
    /// - parameter readingMode (optional): seealso `Data.ReadingOptions`
    @discardableResult
    public func write(toFile url: URL?, options: Data.WritingOptions = []) -> Error? {
        guard let url = url, url.isFileURL else {
            return NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        }

        do {
            try self.write(to: url, options: options)
            return nil
        } catch let err as NSError {
            return err
        }
    }
}
