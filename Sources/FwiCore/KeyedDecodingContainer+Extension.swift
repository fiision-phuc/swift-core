//  File name   : KeyedDecodingContainer+Extension.swift
//
//  Author      : Phuc, Tran Huu
//  Editor      : Dung Vu
//  Created date: 10/24/17
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

public extension KeyedDecodingContainer {
    /// Bool.
    func decode(_ key: KeyedDecodingContainer.Key) throws -> Bool {
        do {
            return try decode(Bool.self, forKey: key)
        } catch DecodingError.typeMismatch(let type, let context) {
            let resString = self[key]
            switch resString {
            case .success(let value):
                let final = value.lowercased().trim()
                switch final {
                case "false": return false
                case "true": return true
                default: break
                }
                if let n = numberFormatter.number(from: final) {
                    return n.boolValue
                }
            case .failure:
                if let resInt = try? self[key, Int.self].get() {
                    return resInt != 0
                }
            }

            throw DecodingError.typeMismatch(type, context)
        }
    }

    /// Float.
    func decode(_ key: KeyedDecodingContainer.Key) throws -> Float {
        do {
            return try decode(Float.self, forKey: key)
        } catch DecodingError.typeMismatch(let type, let context) {
            return try numberCast(by: key, get: .typeMismatch(type, context), transform: { $0.floatValue })
        }
    }

    /// Double.
    func decode(_ key: KeyedDecodingContainer.Key) throws -> Double {
        do {
            return try decode(Double.self, forKey: key)
        } catch DecodingError.typeMismatch(let type, let context) {
            return try numberCast(by: key, get: .typeMismatch(type, context), transform: { $0.doubleValue })
        }
    }

    /// Signed/Unsigned integer.
    func decode<T: Codable & SignedInteger>(_ key: KeyedDecodingContainer.Key) throws -> T {
        do {
            return numericCast(try decode(Int64.self, forKey: key))
        } catch DecodingError.typeMismatch(let type, let context) {
            return try numberCast(by: key, get: .typeMismatch(type, context), transform: { numericCast($0.int64Value) })
        }
    }

    func decode<T: Codable & UnsignedInteger>(_ key: KeyedDecodingContainer.Key) throws -> T {
        do {
            return numericCast(try decode(UInt64.self, forKey: key))
        } catch DecodingError.typeMismatch(let type, let context) {
            return try numberCast(by: key, get: .typeMismatch(type, context), transform: { numericCast($0.uint64Value) })
        }
    }

    /// Data.
    func decode(_ key: KeyedDecodingContainer.Key) throws -> Data {
        do {
            return try decode(Data.self, forKey: key)
        } catch DecodingError.dataCorrupted(let context) {
            let resString = self[key]
            switch resString {
            case .success(let value) where !value.isEmpty:
                if value.isHex, let d = value.decodeHexData() {
                    return d
                } else if let d = value.toData() {
                    return d
                }
            default: break
            }
            throw DecodingError.dataCorrupted(context)
        }
    }

    /// Date.
    func decode(_ key: KeyedDecodingContainer.Key) throws -> Date {
        do {
            return try decode(Date.self, forKey: key)
        } catch DecodingError.typeMismatch(let type, let context) {
            if let value = try? self[key, TimeInterval.self].get() {
                return Date(timeIntervalSince1970: value)

            } else if let value = try? self[key].get() {
                if let date = dateISO8601Formatter.date(from: value) {
                    return date

                } else if let n = numberFormatter.number(from: value) {
                    return Date(timeIntervalSince1970: n.doubleValue)
                }
            }
            throw DecodingError.typeMismatch(type, context)
        }
    }

    /// String.
    func decode(_ key: KeyedDecodingContainer.Key) throws -> String {
        return try decode(String.self, forKey: key)
    }

    /// Codable (e.g: enum, Struct, ...).
    func decode<T: Codable>(_ key: KeyedDecodingContainer.Key) throws -> T {
        return try decode(T.self, forKey: key)
    }
}

private extension KeyedDecodingContainer {
    subscript(key: Key) -> Result<String, Error> {
        let value = self[key, String.self]
        return value
    }

    subscript<T: Decodable>(key: Key, type: T.Type) -> Result<T, Error> {
        let value = Result { try self.decode(type, forKey: key) }
        return value
    }

    func number(by key: Key) -> NSNumber? {
        let res = self[key]
        switch res {
        case .success(let value):
            return numberFormatter.number(from: value)
        case .failure:
            return nil
        }
    }

    func numberCast<T>(by key: Key, get error: @autoclosure () -> DecodingError, transform: (NSNumber) -> T) throws -> T {
        guard let number = self.number(by: key) else {
            throw error()
        }
        return transform(number)
    }
}

/// Define default date format.
internal let dateISO8601Formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    return formatter
}()

/// Define default number format.
internal let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()

    formatter.locale = Locale(identifier: "en_US")
    formatter.formatterBehavior = .behavior10_4
    formatter.generatesDecimalNumbers = false
    formatter.roundingMode = .halfUp
    formatter.numberStyle = .none
    return formatter
}()
