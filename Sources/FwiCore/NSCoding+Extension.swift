//  File name   : NSCoding+Extension.swift
//
//  Author      : Phuc, Tran Huu
//  Editor      : Dung Vu
//  Created date: 9/3/16
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

// MARK: IO to Data
public extension NSCoding {
    /// Unarchive from data.
    ///
    /// - parameter data (required): object's data
    static func unarchive(_ fromData: Data) throws -> Self {
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: fromData) as? Self else {
            let error = NSError(domain: FwiCore.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not decode data into \(String(describing: self))."])
            throw error
        }
        return object
    }

    /// Archive to data.
    func archive() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}

// MARK: IO to File

public extension NSCoding {
    /// Unarchive from file.
    ///
    /// - parameter file (required): destination url
    static func unarchive(_ fromFileURL: URL?) throws -> Self {
        return try unarchive(Data.read(fromFileURL))
    }

    /// Archive to file.
    ///
    /// - parameter file (required): source url
    func archive(_ toFileURL: URL?) throws {
        try archive().write(toFileURL)
    }
}

// MARK: IO to UserDefaults

public extension NSCoding {
    /// Unarchive from UserDefaults.
    ///
    /// - parameter key (required): object's key inside UserDefaults
    static func unarchive(_ fromUserDefaultsKey: String) throws -> Self {
        guard let data = UserDefaults.standard.value(forKey: fromUserDefaultsKey) as? Data, data.count > 0 else {
            let error = NSError(domain: FwiCore.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Input data must not be nil."])
            throw error
        }
        return try unarchive(data)
    }

    /// Archive to UserDefaults.
    ///
    /// - parameter key (required): object's key to store inside UserDefaults
    @discardableResult
    func archive(_ toUserDefaultsKey: String) -> Bool {
        let userDefault = UserDefaults.standard

        userDefault.set(archive(), forKey: toUserDefaultsKey)
        return userDefault.synchronize()
    }
}
