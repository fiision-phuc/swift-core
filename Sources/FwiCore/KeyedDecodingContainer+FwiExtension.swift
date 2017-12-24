//  Project name: FwiCore
//  File name   : KeyedDecodingContainer+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 10/24/17
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


// MARK: Optional
public extension KeyedDecodingContainer {

    /// Bool.
    public func parse(_ input: inout Bool?, key: KeyedDecodingContainer.Key) {
        do {
            input = try decode(Bool.self, forKey: key)
        } catch DecodingError.typeMismatch {
            if let value = try? decode(String.self, forKey: key).lowercased() {
                if let n = numberFormatter.number(from: value) {
                    input = n.boolValue
                } else if value == "false" {
                    input = false
                } else if value == "true" {
                    input = true
                } else {
                    input = nil
                }
            } else if let value = try? decode(Int.self, forKey: key) {
                input = value == 0 ? false : true
            } else {
                input = nil
            }
        } catch {
            input = nil
        }
    }

    /// Float.
    public func parse(_ input: inout Float?, key: KeyedDecodingContainer.Key) {
        do {
            input = try decode(Float.self, forKey: key)
        } catch DecodingError.typeMismatch {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                input = n.floatValue
            } else {
                input = nil
            }
        } catch {
            input = nil
        }
    }

    /// Double.
    public func parse(_ input: inout Double?, key: KeyedDecodingContainer.Key) {
        do {
            input = try decode(Double.self, forKey: key)
        } catch DecodingError.typeMismatch {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                input = n.doubleValue
            } else {
                input = nil
            }
        } catch {
            input = nil
        }
    }

    /// Signed/Unsigned integer.
    public func parse<T: Codable & SignedInteger>(_ input: inout T?, key: KeyedDecodingContainer.Key) {
        do {
            input = numericCast(try decode(Int64.self, forKey: key))
        } catch DecodingError.typeMismatch {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                input = numericCast(n.int64Value)
            } else {
                input = nil
            }
        } catch {
            input = nil
        }
    }
    public func parse<T: Codable & UnsignedInteger>(_ input: inout T?, key: KeyedDecodingContainer.Key) {
        do {
            input = numericCast(try decode(UInt64.self, forKey: key))
        } catch DecodingError.typeMismatch {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                input = numericCast(n.uint64Value)
            } else {
                input = nil
            }
        } catch {
            input = nil
        }
    }

    /// Data.
    public func parse(_ input: inout Data?, key: KeyedDecodingContainer.Key) {
        do {
            input = try decode(Data.self, forKey: key)
        } catch {
            if let value = try? decode(String.self, forKey: key) {
                if value.isHex, let d = value.decodeHexData() {
                    input = d
                } else if let d = value.toData() {
                    input = d
                } else {
                    input = nil
                }
            } else {
                input = nil
            }
        }
    }

    /// Date.
    public func parse(_ input: inout Date?, key: KeyedDecodingContainer.Key) {
        do {
            input = try decode(Date.self, forKey: key)
        } catch DecodingError.typeMismatch {
            if let value = try? decode(TimeInterval.self, forKey: key) {
                input = Date(timeIntervalSince1970: value)
            } else {
                input = nil
            }
        } catch {
            if let value = try? decode(String.self, forKey: key), let n = numberFormatter.number(from: value) {
                input = Date(timeIntervalSince1970: n.doubleValue)
            } else {
                input = nil
            }
        }
    }

    /// String.
    public func parse(_ input: inout String?, key: KeyedDecodingContainer.Key) {
        do {
            input = try decode(String.self, forKey: key)
        } catch {
            input = nil
        }
    }

    /// URL.
    public func parse(_ input: inout URL?, key: KeyedDecodingContainer.Key) {
        do {
            input = try decode(URL.self, forKey: key)
        } catch {
            input = nil
        }
    }

    /// Other.
    public func parse<T: Codable>(_ input: inout T?, key: KeyedDecodingContainer.Key) {
        do {
            input = try decode(T.self, forKey: key)
        } catch {
            input = nil
        }
    }
}

// MARK: Non optional
public extension KeyedDecodingContainer {

    /// Bool.
    public func parse(_ input: inout Bool, key: KeyedDecodingContainer.Key) {
//        return (left + right) ?? false
    }

    /// Float.
    public func parse(_ input: inout Float, key: KeyedDecodingContainer.Key) {
//        return (left + right) ?? 0.0
    }

    /// Double.
    public func parse(_ input: inout Double, key: KeyedDecodingContainer.Key) {
//        return (left + right) ?? 0.0
    }

    /// Signed/Unsigned integer.
    public func parse<T: Codable & SignedInteger>(_ input: inout T, key: KeyedDecodingContainer.Key) {
//        return (left + right) ?? 0
    }
    public func parse<T: Codable & UnsignedInteger>(_ input: inout T, key: KeyedDecodingContainer.Key) {
//        return (left + right) ?? 0
    }

    /// Data.
    public func parse(_ input: inout Data, key: KeyedDecodingContainer.Key) {
    }

    /// Date.
    public func parse(_ input: inout Date, key: KeyedDecodingContainer.Key) {
    }

    /// String.
    public func parse(_ input: inout String, key: KeyedDecodingContainer.Key) {
        //        return (left + right) ?? ""
    }

    /// Other.
    public func parse<T: Codable>(_ input: inout T, key: KeyedDecodingContainer.Key) {
//        return try left.decode(T.self, forKey: right)
    }
}

/// Define default number format.
fileprivate let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()

    formatter.locale = Locale(identifier: "en_US")
    formatter.formatterBehavior = .behavior10_4
    formatter.generatesDecimalNumbers = false
    formatter.roundingMode = .halfUp
    formatter.numberStyle = .none
    return formatter
}()
