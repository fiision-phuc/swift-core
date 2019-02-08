//  File name   : KeyedDecodingContainer+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
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
    public func decode(key: KeyedDecodingContainer.Key) throws -> Bool {
        do {
            return try decode(Bool.self, forKey: key)
        } catch DecodingError.typeMismatch(let type, let context) {
            if let value = try? decode(String.self, forKey: key) {
                let final = value.trim().lowercased()

                if let n = numberFormatter.number(from: final) {
                    return n.boolValue
                } else if final == "false" {
                    return false
                } else if final == "true" {
                    return true
                }
            } else if let value = try? decode(Int.self, forKey: key) {
                return (value == 0 ? false : true)
            }
            throw DecodingError.typeMismatch(type, context)
        }
    }

    /// Float.
    public func decode(key: KeyedDecodingContainer.Key) throws -> Float {
        do {
            return try decode(Float.self, forKey: key)
        } catch DecodingError.typeMismatch(let type, let context) {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                return n.floatValue
            }
            throw DecodingError.typeMismatch(type, context)
        }
    }

    /// Double.
    public func decode(key: KeyedDecodingContainer.Key) throws -> Double {
        do {
            return try decode(Double.self, forKey: key)
        } catch DecodingError.typeMismatch(let type, let context) {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                return n.doubleValue
            }
            throw DecodingError.typeMismatch(type, context)
        }
    }

    /// Signed/Unsigned integer.
    public func decode<T: Codable & SignedInteger>(key: KeyedDecodingContainer.Key) throws -> T {
        do {
            return numericCast(try decode(Int64.self, forKey: key))
        } catch DecodingError.typeMismatch(let type, let context) {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                return numericCast(n.int64Value)
            }
            throw DecodingError.typeMismatch(type, context)
        }
    }

    public func decode<T: Codable & UnsignedInteger>(key: KeyedDecodingContainer.Key) throws -> T {
        do {
            return numericCast(try decode(UInt64.self, forKey: key))
        } catch DecodingError.typeMismatch(let type, let context) {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                return numericCast(n.uint64Value)
            }
            throw DecodingError.typeMismatch(type, context)
        }
    }

    /// Data.
    public func decode(key: KeyedDecodingContainer.Key) throws -> Data {
        do {
            return try decode(Data.self, forKey: key)
        } catch DecodingError.dataCorrupted(let context) {
            if let value = try? decode(String.self, forKey: key) {
                if value.isHex, let d = value.decodeHexData() {
                    return d
                } else if let d = value.toData() {
                    return d
                }
            }
            throw DecodingError.dataCorrupted(context)
        }
    }

    /// Date.
    public func decode(key: KeyedDecodingContainer.Key) throws -> Date {
        do {
            return try decode(Date.self, forKey: key)
        } catch DecodingError.typeMismatch(let type, let context) {
            if let value = try? decode(TimeInterval.self, forKey: key) {
                return Date(timeIntervalSince1970: value)

            } else if let value = try? decode(String.self, forKey: key) {
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
    public func decode(key: KeyedDecodingContainer.Key) throws -> String {
        return try decode(String.self, forKey: key)
    }

    /// URL.
    public func decode(key: KeyedDecodingContainer.Key) throws -> URL {
        return try decode(URL.self, forKey: key)
    }

    /// Other.
    public func decode<T: Codable>(key: KeyedDecodingContainer.Key) throws -> T {
        return try decode(T.self, forKey: key)
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
