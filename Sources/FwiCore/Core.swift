//  File name   : Core.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/20/14
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

public typealias ExecutingBlock = () -> Void
public typealias OmitBlock = (Error) -> Void

public struct FwiCore {
    public static let domain = "com.fiision.lib.FwiCore"

    /// Custom error handler for tryOmitsThrow function.
    public static var omitBlock: OmitBlock?

    /// Enable /Disable error output into console.
    public static var debug = false {
        didSet {
            guard debug else { return }
            Log.consoleLog()
        }
    }

    public static var currentLocale: String {
        get {
            return shared.locale
        }
        set(newLocale) {
            shared.locale = newLocale
        }
    }

    /// Execute functions in sequence.
    ///
    /// - Parameter functions: list of functions
    public static func executeFunctions(_ functions: ExecutingBlock...) {
        functions.forEach { $0() }
    }

    /// Localize string for string. The original string will be returned if a localized string could
    /// not be found.
    ///
    /// - Parameter string: an original string
    public static func localized(_ text: String?) -> String {
        guard let text = text, text.count > 0 else { return "" }
        return shared.localized(text)
    }

    /// Calculate execution time.
    ///
    /// - Parameter block: execution block
    @discardableResult
    public static func time<T>(_ block: () -> T) -> T {
        let date = Date()
        defer {
            print("Time interval: \(abs(date.timeIntervalSinceNow))")
        }
        return block()
    }

    /// Perform try and omits throws.
    ///
    /// - Parameters:
    ///   - block: try block
    ///   - default: default value in case try block failed will be returned
    public static func tryOmitsThrow<T>(_ block: () throws -> T, default: @autoclosure () -> T, className: String = #file, line: Int = #line) -> T {
        do {
            return try block()
        } catch {
            Log.error(error, className: className, line: line)
            omitBlock?(error)
            return `default`()
        }
    }

    /// Struct's private static properties.
    private static var shared = Localization()
}

/// Internal usage.
///
/// - Parameter block: execution block
func execution<T>(_ block: () throws -> T) rethrows -> T {
    return try block()
}
