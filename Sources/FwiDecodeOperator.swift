//  Project name: FwiCore
//  File name   : FwiJSONDecodeOperator.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/19/17
//  Version     : 1.00
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


/// Define default datetime format.
internal let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
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

// MARK: Bool
public func <-<T>(left: inout Bool, right: T?) {
    if let r = right as? NSNumber {
        left = r.boolValue
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left = n.boolValue
    }
}
public func <-<T>(left: inout Bool?, right: T?) {
    if let r = right as? NSNumber {
        left = r.boolValue
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left = n.boolValue
    } else {
        left = nil
    }
}

// MARK: Sign integer
public func <-<T: SignedInteger, U>(left: inout T, right: U?) {
    if let r = right as? NSNumber {
        if T.self == Int.self {
            left = T(IntMax(r.intValue))
        } else if T.self == Int8.self {
            left = T(IntMax(r.int8Value))
        } else if T.self == Int16.self {
            left = T(IntMax(r.int16Value))
        } else if T.self == Int32.self {
            left = T(IntMax(r.int32Value))
        } else if T.self == Int64.self {
            left = T(IntMax(r.int64Value))
        }
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left <- n
    }
}
public func <-<T: SignedInteger, U>(left: inout T?, right: U?) {
    if let r = right as? NSNumber {
        if T.self == Int.self {
            left = T(IntMax(r.intValue))
        } else if T.self == Int8.self {
            left = T(IntMax(r.int8Value))
        } else if T.self == Int16.self {
            left = T(IntMax(r.int16Value))
        } else if T.self == Int32.self {
            left = T(IntMax(r.int32Value))
        } else if T.self == Int64.self {
            left = T(IntMax(r.int64Value))
        }
    } else if let r = right as? String, let n =  IntMax(r) {// numberFormatter.number(from: r) {
//        } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left = T(n)
//        left <- n
    } else {
        left = nil
    }
}

// MARK: Unsign integer
public func <-<T: UnsignedInteger, U>(left: inout T, right: U?) {
    if let r = right as? NSNumber {
        if T.self == UInt.self {
            left = T(UIntMax(r.uintValue))
        } else if T.self == UInt8.self {
            left = T(UIntMax(r.uint8Value))
        } else if T.self == UInt16.self {
            left = T(UIntMax(r.uint16Value))
        } else if T.self == UInt32.self {
            left = T(UIntMax(r.uint32Value))
        } else if T.self == UInt64.self {
            left = T(UIntMax(r.uint64Value))
        }
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left <- n
    }
}
public func <-<T: UnsignedInteger, U>(left: inout T?, right: U?) {
    if let r = right as? NSNumber {
        if T.self == UInt.self {
            left = T(UIntMax(r.uintValue))
        } else if T.self == UInt8.self {
            left = T(UIntMax(r.uint8Value))
        } else if T.self == UInt16.self {
            left = T(UIntMax(r.uint16Value))
        } else if T.self == UInt32.self {
            left = T(UIntMax(r.uint32Value))
        } else if T.self == UInt64.self {
            left = T(UIntMax(r.uint64Value))
        }
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left <- n
    } else {
        left = nil
    }
}

// MARK: Float
/// Float32 -> Float
/// Float64 -> Double
public func <-<T>(left: inout Float, right: T?) {
    if let r = right as? NSNumber {
        left = r.floatValue
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left = n.floatValue
    }
}
public func <-<T>(left: inout Float?, right: T?) {
    if let r = right as? NSNumber {
        left = r.floatValue
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left = n.floatValue
    } else {
        left = nil
    }
}

// MARK: Double
public func <-<T>(left: inout Double, right: T?) {
    if let r = right as? NSNumber {
        left = r.doubleValue
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left = n.doubleValue
    }
}
public func <-<T>(left: inout Double?, right: T?) {
    if let r = right as? NSNumber {
        left = r.doubleValue
    } else if let r = right as? String, let n = numberFormatter.number(from: r) {
        left = n.doubleValue
    } else {
        left = nil
    }
}

// MARK: Data
public func <-<T>(left: inout Data, right: T?) {
    if let r = right as? Data {
        left = r
    } else if let r = right as? String, let v = r.decodeBase64Data() ?? r.toData() {
        left = v
    }
}
public func <-<T>(left: inout Data?, right: T?) {
    if let r = right as? Data {
        left = r
    } else if let r = right as? String, let v = r.decodeBase64Data() ?? r.toData() {
        left = v
    } else {
        left = nil
    }
}

// MARK: Date
public func <-<T>(left: inout Date, right: T?) {
    if let r = right as? Date {
        left = r
    } else if let r = right as? NSNumber {
        left = Date(timeIntervalSince1970: r.doubleValue)
    } else if let r = right as? String, let d = dateFormatter.date(from: r) {
        left = d
    }
}
public func <-<T>(left: inout Date?, right: T?) {
    if let r = right as? Date {
        left = r
    } else if let r = right as? NSNumber {
        left = Date(timeIntervalSince1970: r.doubleValue)
    } else if let r = right as? String, let d = dateFormatter.date(from: r) {
        left = d
    }else {
        left = nil
    }
}

public func <-<T>(left: DateFormatter, right: T?) -> Date? {
    guard let r = right as? String, let date = left.date(from: r) else {
        return nil
    }
    return date
}
public func <-<T>(left: DateFormatter?, right: T?) -> Date? {
    guard let r = right as? String, let date = left?.date(from: r) else {
        return nil
    }
    return date
}

// MARK: String
public func <-<T>(left: inout String, right: T?) {
    if let r = right as? String {
        left = r
    } else if let r = right as? CustomStringConvertible {
        left = r.description
    }
}
public func <-<T>(left: inout String?, right: T?) {
    if let r = right as? String {
        left = r
    } else if let r = right as? CustomStringConvertible {
        left = r.description
    } else {
        left = nil
    }
}

// MARK: URL
public func <-<T>(left: inout URL, right: T?) {
    if let r = right as? URL {
        left = r
    } else if let r = right as? String, let url = URL(string: r) {
        left = url
    }
}
public func <-<T>(left: inout URL?, right: T?) {
    if let r = right as? URL {
        left = r
    } else if let r = right as? String, let url = URL(string: r) {
        left = url
    } else {
        left = nil
    }
}

// MARK: FwiJSON
public func <-<T: FwiJSONModel, U>(left: inout T, right: U?) {
    if let r = right as? T {
        left = r
    } else if let r = right as? JSON {
        left = T(withJSON: r)
    }
}
public func <-<T: FwiJSONModel, U>(left: inout T?, right: U?) {
    if let r = right as? T {
        left = r
    } else if let r = right as? JSON {
        left = T(withJSON: r)
    } else {
        left = nil
    }
}

// MARK: Array
public func <-<T>(left: inout [Bool], right: T?) {
    if let r = right as? [Bool] {
        left = r
    } else if let r = right as? [String] {
        left.append(contentsOf: r.flatMap { Bool($0) })
    }
}
public func <-<T>(left: inout [Bool]?, right: T?) {
    if let r = right as? [Bool] {
        left = r
    } else if let r = right as? [String] {
        let result = r.flatMap { Bool($0) }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T: SignedInteger, U>(left: inout [T], right: U?) {
    if let r = right as? [T] {
        left = r
    } else if let r = right as? [String] {
        let result = r.flatMap { (item) -> T? in
            var aValue: T?
            aValue <- item
            return aValue
        }
        left.append(contentsOf: result)
    }
}
public func <-<T: SignedInteger, U>(left: inout [T]?, right: U?) {
    if let r = right as? [T] {
        left = r
    } else if let r = right as? [String] {
        let result = r.flatMap { (item) -> T? in
            var aValue: T?
            aValue <- item
            return aValue
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T: UnsignedInteger, U>(left: inout [T], right: U?) {
    if let r = right as? [T] {
        left = r
    } else if let r = right as? [String] {
        let result = r.flatMap { (item) -> T? in
            var aValue: T?
            aValue <- item
            return aValue
        }
        left.append(contentsOf: result)
    }
}
public func <-<T: UnsignedInteger, U>(left: inout [T]?, right: U?) {
    if let r = right as? [T] {
        left = r
    } else if let r = right as? [String] {
        let result = r.flatMap { (item) -> T? in
            var aValue: T?
            aValue <- item
            return aValue
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [Float], right: T?) {
    if let r = right as? [Float] {
        left = r
    } else if let r = right as? [String] {
        left.append(contentsOf: r.flatMap { numberFormatter.number(from: $0)?.floatValue })
    }
}
public func <-<T>(left: inout [Float]?, right: T?) {
    if let r = right as? [Float] {
        left = r
    } else if let r = right as? [String] {
        let result = r.flatMap { numberFormatter.number(from: $0)?.floatValue }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [Double], right: T?) {
    if let r = right as? [Double] {
        left = r
    } else if let r = right as? [String] {
        r.forEach { (value) in
            var aValue: Double?
            aValue <- value

            if let v = aValue {
                left.append(v)
            }
        }
    }
}
public func <-<T>(left: inout [Double]?, right: T?) {
    if let r = right as? [Double] {
        left = r
    } else if let r = right as? [String] {
        var result = [Double]()
        r.forEach { (value) in
            var aValue: Double?
            aValue <- value

            if let v = aValue {
                result.append(v)
            }
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [Data], right: T?) {
    if let r = right as? [Data] {
        left = r
    } else if let r = right as? [String] {
        r.forEach { (value) in
            guard let data = value.decodeBase64Data() ?? value.toData() else {
                return
            }
            left.append(data)
        }
    }
}
public func <-<T>(left: inout [Data]?, right: T?) {
    if let r = right as? [Data] {
        left = r
    } else if let r = right as? [String] {
        var result = [Data]()
        r.forEach { (value) in
            guard let data = value.decodeBase64Data() ?? value.toData() else {
                return
            }
            result.append(data)
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [Date], right: T?) {
    if let r = right as? [Date] {
        left = r
    } else if let r = right as? [String] {
        r.forEach { (value) in
            guard let date = dateFormatter.date(from: value) else {
                return
            }
            left.append(date)
        }
    }
}
public func <-<T>(left: inout [Date]?, right: T?) {
    if let r = right as? [Date] {
        left = r
    } else if let r = right as? [String] {
        var result = [Date]()
        r.forEach { (value) in
            guard let date = dateFormatter.date(from: value) else {
                return
            }
            result.append(date)
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [String], right: T?) {
    if let r = right as? [String] {
        left = r
    } else if let r = right as? [CustomStringConvertible] {
        left.append(contentsOf: r.map { $0.description })
    }
}
public func <-<T>(left: inout [String]?, right: T?) {
    if let r = right as? [String] {
        left = r
    } else if let r = right as? [CustomStringConvertible] {
        let result = r.map { $0.description }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [URL], right: T?) {
    if let r = right as? [URL] {
        left = r
    } else if let r = right as? [String] {
        r.forEach { (item) in
            guard let url = URL(string: item) else {
                return
            }
            left.append(url)
        }
    }
}
public func <-<T>(left: inout [URL]?, right: T?) {
    if let r = right as? [URL] {
        left = r
    } else if let r = right as? [String] {
        var result = [URL]()
        r.forEach { (item) in
            guard let url = URL(string: item) else {
                return
            }
            result.append(url)
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T: FwiJSONModel, U>(left: inout [T], right: U?) {
    if let r = right as? [T] {
        left = r
    } else if let r = right as? [JSON] {
        left.append(contentsOf: r.map { T(withJSON: $0) })
    }
}
public func <-<T: FwiJSONModel, U>(left: inout [T]?, right: U?) {
    if let r = right as? [T] {
        left = r
    } else if let r = right as? [JSON] {
        let result = r.map { T(withJSON: $0) }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [Any], right: T?) {
    guard let r = right as? [Any] else {
        return
    }
    left = r
}
public func <-<T>(left: inout [Any]?, right: T?) {
    guard let r = right as? [Any] else {
        return
    }
    left = r.count > 0 ? r : nil
}

// MARK: Dictionary
public func <-<T>(left: inout [String:Bool], right: T?) {
    if let r = right as? [String:Bool] {
        left = r
    } else if let r = right as? [String:String] {
        r.forEach { (item) in
            var aBool: Bool?
            aBool <- item.value

            if let b = aBool {
                left[item.key] = b
            }
        }
    }
}
public func <-<T>(left: inout [String:Bool]?, right: T?) {
    if let r = right as? [String:Bool] {
        left = r
    } else if let r = right as? [String:String] {
        var result = [String:Bool](minimumCapacity: r.count)
        r.forEach { (item) in
            var aBool: Bool?
            aBool <- item.value

            if let b = aBool {
                result[item.key] = b
            }
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T: SignedInteger, U>(left: inout [String:T], right: U?) {
    if let r = right as? [String:T] {
        left = r
    } else if let r = right as? [String:String] {
        r.forEach { (item) in
            var aValue: T?
            aValue <- item.value

            if let v = aValue {
                left[item.key] = v
            }
        }
    }
}
public func <-<T: SignedInteger, U>(left: inout [String:T]?, right: U?) {
    if let r = right as? [String:T] {
        left = r
    } else if let r = right as? [String:String] {
        var result = [String:T](minimumCapacity: r.count)
        r.forEach { (item) in
            var aValue: T?
            aValue <- item.value

            if let v = aValue {
                result[item.key] = v
            }
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T: UnsignedInteger, U>(left: inout [String:T], right: U?) {
    if let r = right as? [String:T] {
        left = r
    } else if let r = right as? [String:String] {
        r.forEach { (item) in
            var aValue: T?
            aValue <- item.value

            if let v = aValue {
                left[item.key] = v
            }
        }
    }
}
public func <-<T: UnsignedInteger, U>(left: inout [String:T]?, right: U?) {
    if let r = right as? [String:T] {
        left = r
    } else if let r = right as? [String:String] {
        var result = [String:T](minimumCapacity: r.count)
        r.forEach { (item) in
            var aValue: T?
            aValue <- item.value

            if let v = aValue {
                result[item.key] = v
            }
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [String:Float], right: T?) {
    if let r = right as? [String:Float] {
        left = r
    } else if let r = right as? [String:String] {
        r.forEach { (item) in
            guard let n = numberFormatter.number(from: item.value) else {
                return
            }
            left[item.key] = n.floatValue
        }
    }
}
public func <-<T>(left: inout [String:Float]?, right: T?) {
    if let r = right as? [String:Float] {
        left = r
    } else if let r = right as? [String:String] {
        var result = [String:Float](minimumCapacity: r.count)
        r.forEach { (item) in
            guard let n = numberFormatter.number(from: item.value) else {
                return
            }
            result[item.key] = n.floatValue
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [String:Double], right: T?) {
    if let r = right as? [String:Double] {
        left = r
    } else if let r = right as? [String:String] {
        r.forEach { (item) in
            guard let n = numberFormatter.number(from: item.value) else {
                return
            }
            left[item.key] = n.doubleValue
        }
    }
}
public func <-<T>(left: inout [String:Double]?, right: T?) {
    if let r = right as? [String:Double] {
        left = r
    } else if let r = right as? [String:String] {
        var result = [String:Double](minimumCapacity: r.count)
        r.forEach { (item) in
            guard let n = numberFormatter.number(from: item.value) else {
                return
            }
            result[item.key] = n.doubleValue
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [String:Data], right: T?) {
    if let r = right as? [String:Data] {
        left = r
    } else if let r = right as? [String:String] {
        r.forEach { (item) in
            var aData: Data?
            aData <- item.value

            if let data = aData {
                left[item.key] = data
            }
        }
    }
}
public func <-<T>(left: inout [String:Data]?, right: T?) {
    if let r = right as? [String:Data] {
        left = r
    } else if let r = right as? [String:String] {
        var result = [String:Data](minimumCapacity: r.count)
        r.forEach { (item) in
            var aData: Data?
            aData <- item.value

            if let data = aData {
                result[item.key] = data
            }
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [String:Date], right: T?) {
    if let r = right as? [String:Date] {
        left = r
    } else if let r = right as? [String:String] {
        r.forEach { (item) in
            var aDate: Date?
            aDate <- item.value

            if let date = aDate {
                left[item.key] = date
            }
        }
    }
}
public func <-<T>(left: inout [String:Date]?, right: T?) {
    if let r = right as? [String:Date] {
        left = r
    } else if let r = right as? [String:String] {
        var result = [String:Date](minimumCapacity: r.count)
        r.forEach { (item) in
            var aDate: Date?
            aDate <- item.value

            if let date = aDate {
                result[item.key] = date
            }
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [String:String], right: T?) {
    if let r = right as? [String:String] {
        left = r
    } else if let r = right as? [String:CustomStringConvertible] {
        r.forEach { (item) in
            left[item.key] = item.value.description
        }
    }
}
public func <-<T>(left: inout [String:String]?, right: T?) {
    if let r = right as? [String:String] {
        left = r
    } else if let r = right as? [String:CustomStringConvertible] {
        var result = [String:String](minimumCapacity: r.count)
        r.forEach { (item) in
            result[item.key] = item.value.description
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [String:URL], right: T?) {
    if let r = right as? [String:URL] {
        left = r
    } else if let r = right as? [String:String] {
        r.forEach { (item) in
            var aUrl: URL?
            aUrl <- item.value

            if let url = aUrl {
                left[item.key] = url
            }
        }
    }
}
public func <-<T>(left: inout [String:URL]?, right: T?) {
    if let r = right as? [String:URL] {
        left = r
    } else if let r = right as? [String:String] {
        var result = [String:URL](minimumCapacity: r.count)
        r.forEach { (item) in
            var aUrl: URL?
            aUrl <- item.value

            if let url = aUrl {
                result[item.key] = url
            }
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T: FwiJSONModel, U>(left: inout [String:T], right: U?) {
    if let r = right as? [String:T] {
        left = r
    } else if let r = right as? [String:JSON] {
        r.forEach { (item) in
            left[item.key] = T(withJSON: item.value)
        }
    }
}
public func <-<T: FwiJSONModel, U>(left: inout [String:T]?, right: U?) {
    if let r = right as? [String:T] {
        left = r
    } else if let r = right as? [String:JSON] {
        var result = [String:T](minimumCapacity: r.count)
        r.forEach { (item) in
            result[item.key] = T(withJSON: item.value)
        }
        left = result.count > 0 ? result : nil
    } else {
        left = nil
    }
}

public func <-<T>(left: inout [String:Any], right: T?) {
    guard let r = right as? [String:Any] else {
        return
    }
    left = r
}
public func <-<T>(left: inout [String:Any]?, right: T?) {
    guard let r = right as? [String:Any] else {
        return
    }
    left = r.count > 0 ? r : nil
}
