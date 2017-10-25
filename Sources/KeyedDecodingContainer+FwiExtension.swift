//  Project name: FwiCore
//  File name   : KeyedDecodingContainer+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 10/24/17
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


// MARK: Optional
public extension KeyedDecodingContainer {

    /// Bool.
    static public func +(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> Bool? {
        return try? left.decode(Bool.self, forKey: right)
    }

    /// Float.
    static public func +(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> Float? {
        do {
            return try left.decode(Float.self, forKey: right)
        } catch DecodingError.typeMismatch {
            if let value = try? left.decode(String.self, forKey: right), let n = numberFormatter.number(from: value) {
                return n.floatValue
            }
        } catch {
            // Ignore others
        }
        return nil
    }

    /// Double.
    static public func +(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> Double? {
        do {
            return try left.decode(Double.self, forKey: right)
        } catch DecodingError.typeMismatch {
            if let value = try? left.decode(String.self, forKey: right), let n = numberFormatter.number(from: value) {
                return n.doubleValue
            }
        } catch {
            // Ignore others
        }
        return nil
    }

    /// String.
    static public func +(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> String? {
        return try? left.decode(String.self, forKey: right)
    }

    /// Signed/Unsigned integer.
    static public func +<T: Codable & BinaryInteger>(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> T? {
        do {
            if T.self == Int.self {
                return T(try left.decode(Int.self, forKey: right))
            } else if T.self == Int8.self {
                return T(try left.decode(Int8.self, forKey: right))
            } else if T.self == Int16.self {
                return T(try left.decode(Int16.self, forKey: right))
            } else if T.self == Int32.self {
                return T(try left.decode(Int32.self, forKey: right))
            } else if T.self == Int64.self {
                return T(try left.decode(Int64.self, forKey: right))
            } else if T.self == UInt.self {
                return T(try left.decode(UInt.self, forKey: right))
            } else if T.self == UInt8.self {
                return T(try left.decode(UInt8.self, forKey: right))
            } else if T.self == UInt16.self {
                return T(try left.decode(UInt16.self, forKey: right))
            } else if T.self == UInt32.self {
                return T(try left.decode(UInt32.self, forKey: right))
            } else if T.self == UInt64.self {
                return T(try left.decode(UInt64.self, forKey: right))
            }
        } catch DecodingError.typeMismatch {
            if let value = try? left.decode(String.self, forKey: right), let n = numberFormatter.number(from: value) {
                if T.self == Int.self {
                    return T(Int64(n.intValue))
                } else if T.self == Int8.self {
                    return T(Int64(n.int8Value))
                } else if T.self == Int16.self {
                    return T(Int64(n.int16Value))
                } else if T.self == Int32.self {
                    return T(Int64(n.int32Value))
                } else if T.self == Int64.self {
                    return T(Int64(n.int64Value))
                } else if T.self == UInt.self {
                    return T(UInt64(n.uintValue))
                } else if T.self == UInt8.self {
                    return T(UInt64(n.uint8Value))
                } else if T.self == UInt16.self {
                    return T(UInt64(n.uint16Value))
                } else if T.self == UInt32.self {
                    return T(UInt64(n.uint32Value))
                } else if T.self == UInt64.self {
                    return T(UInt64(n.uint64Value))
                }
            }
        } catch {
            // Ignore others
        }
        return nil
    }

    /// Other.
    static public func +<T: Codable>(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> T? {
        return try? left.decode(T.self, forKey: right)
    }
}

// MARK: Non optional
public extension KeyedDecodingContainer {

    /// Bool.
    static public func +(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> Bool {
        return (left + right) ?? false
    }

    /// Float.
    static public func +(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> Float {
        return (left + right) ?? 0.0
    }

    /// Double.
    static public func +(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> Double {
        return (left + right) ?? 0.0
    }

    /// String.
    static public func +(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> String {
        return (left + right) ?? ""
    }

    /// Signed/Unsigned integer.
    static public func +<T: Codable & BinaryInteger>(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) -> T {
        return (left + right) ?? 0
    }

    /// Other.
    static public func +<T: Codable>(left: KeyedDecodingContainer, right: KeyedDecodingContainer.Key) throws -> T {
        return try left.decode(T.self, forKey: right)
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
