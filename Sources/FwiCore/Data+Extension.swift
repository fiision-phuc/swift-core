//  File name   : Data+Extension.swift
//
//  Author      : Phuc, Tran Huu
//  Editor      : Dung Vu
//  Created date: 11/22/14
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

public extension Data {
    /// Clear all bytes data.
    mutating func clearBytes() {
        /* Condition validation */
        if count <= 0 {
            return
        }

        let step = count
        withUnsafeMutableBytes { p in
            guard var pointer = p.bindMemory(to: UInt8.self).baseAddress else {
                return
            }

            for _ in 0 ..< step {
                pointer.pointee = 0
                pointer = pointer.advanced(by: 1)
            }
        }
    }

    /// Reverse the order of bytes.
    mutating func reverseBytes() {
        /* Condition validation */
        if count <= 0 {
            return
        }

        let end = count - 1
        let step = count / 2
        withUnsafeMutableBytes { p in
            guard var p1 = p.bindMemory(to: UInt8.self).baseAddress else {
                return
            }
            var p2 = p1.advanced(by: end)

            for _ in 0 ..< step {
                swap(&p1.pointee, &p2.pointee)
                p1 = p1.advanced(by: 1)
                p2 = p2.advanced(by: -1)
            }
        }
    }

    /// Convert data to string base on string encoding type.
    ///
    /// - parameter encoding: string encoding, default is UTF-8
    func toString(_ encoding: String.Encoding = .utf8) -> String? {
        /* Condition validation */
        if count <= 0 {
            return nil
        }
        return String(data: self, encoding: encoding)
    }

    /// Read data from file.
    ///
    /// - parameter url (required): source url to read from
    /// - parameter readingMode (optional): seealso `Data.ReadingOptions`

    /// Read data from file.
    ///
    /// - Parameters:
    ///   - fromFile: file's url to read data from
    ///   - readingMode: reading mode when open a file, default is none
    static func read(_ fromFile: URL?, readingMode: Data.ReadingOptions = []) throws -> Data {
        guard let fileURL = fromFile, fileURL.isFileURL else {
            let info = [NSLocalizedDescriptionKey: "Could not read data from file at: \(fromFile?.path ?? "")"]
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: info)
        }
        return try Data(contentsOf: fileURL, options: readingMode)
    }

    /// Write data to file.
    ///
    /// - parameter url (required): destination url to write to
    /// - parameter readingMode (optional): seealso `Data.ReadingOptions`

    /// Write data to file.
    ///
    /// - Parameters:
    ///   - toFile: file's url to write data to
    ///   - writingMode: writing mode when open a file, default is none
    func write(_ toFile: URL?, writingMode: Data.WritingOptions = []) throws {
        guard let fileURL = toFile, fileURL.isFileURL else {
            let info = [NSLocalizedDescriptionKey: "Could not write data to file at: \(toFile?.path ?? "")"]
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: info)
        }
        try write(to: fileURL, options: writingMode)
    }
}
