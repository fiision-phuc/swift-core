//  File name   : NSCoding+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/3/16
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

public extension NSCoding {
    // MARK: I/O to Data

    /// Unarchive from data.
    ///
    /// - parameter data (required): object's data
    public static func unarchive(fromData d: Data?) -> Self? {
        guard let data = d else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Self
    }

    /// Archive to data.
    public func archive() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

    // MARK: I/O to File

    /// Unarchive from file.
    ///
    /// - parameter file (required): destination url
    public static func unarchive(fromFile url: URL?) -> Self? {
        return unarchive(fromData: Data.read(fromFile: url))
    }

    /// Archive to file.
    ///
    /// - parameter file (required): source url
    @discardableResult
    public func archive(toFile url: URL?) -> Error? {
        return archive().write(toFile: url)
    }

    // MARK: I/O to UserDefaults

    /// Unarchive from UserDefaults.
    ///
    /// - parameter key (required): object's key inside UserDefaults
    public static func unarchive(fromUserDefaults key: String) -> Self? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data, data.count > 0 else {
            return nil
        }
        return unarchive(fromData: data)
    }

    /// Archive to UserDefaults.
    ///
    /// - parameter key (required): object's key to store inside UserDefaults
    @discardableResult
    public func archive(toUserDefaults key: String) -> Bool {
        let userDefault = UserDefaults.standard

        userDefault.set(archive(), forKey: key)
        return userDefault.synchronize()
    }
}
