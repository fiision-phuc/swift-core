//  File name   : Log.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 2/7/19
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

#if canImport(CocoaLumberjackSwift)
    import CocoaLumberjackSwift
    import Foundation

    public struct FwiLog {
        /// Enable console log.
        public static func consoleLog(withLevel level: DDLogLevel = .debug) {
            defer { logLevel = level }
            DDLog.add(DDOSLogger.sharedInstance)
        }

        /// Enable file log.
        public static func fileLog(withLevel level: DDLogLevel = .info, rollingFrequency: TimeInterval = 60 * 60 * 24, numberOfLogFiles: UInt = 5) {
            consoleLog(withLevel: level)

            /* Condition validation: validate if logs folder can be created or not */
            guard let logsDirectory = URL.documentDirectory()?.appendingPathComponent("Logs").path else {
                return
            }
            let logFileManager = DDLogFileManagerDefault(logsDirectory: logsDirectory)

            /* Condition validation: validate if file logger can be created or not */
            let fileLogger = DDFileLogger(logFileManager: logFileManager)
            fileLogger.logFileManager.maximumNumberOfLogFiles = numberOfLogFiles
            fileLogger.rollingFrequency = rollingFrequency
            DDLog.add(fileLogger)
        }

        /// Log error message.
        ///
        /// - Parameters:
        ///   - items: list of items to be output to console
        public static func error(_ items: Any..., className: String = #file, line: Int = #line) {
            /* Condition validation: validate debug mode */
            guard
                isLevelEnabled(.error),
                let message = formatMessage(at: .error, with: items.map{"\($0)"}, className: className, line: line)
            else {
                return
            }
            DDLogError(message)
        }

        /// Log warning message.
        ///
        /// - Parameters:
        ///   - items: list of items to be output to console
        public static func warning(_ items: Any..., className: String = #file, line: Int = #line) {
            /* Condition validation: validate debug mode */
            guard
                isLevelEnabled(.warning),
                let message = formatMessage(at: .warning, with: items.map{"\($0)"}, className: className, line: line)
            else {
                return
            }
            DDLogWarn(message)
        }

        /// Log info message.
        ///
        /// - Parameters:
        ///   - items: list of items to be output to console
        public static func info(_ items: Any..., className: String = #file, line: Int = #line) {
            /* Condition validation: validate debug mode */
            guard
                isLevelEnabled(.info),
                let message = formatMessage(at: .info, with: items.map{"\($0)"}, className: className, line: line)
            else {
                return
            }
            DDLogInfo(message)
        }

        /// Log debug message.
        ///
        /// - Parameters:
        ///   - items: list of items to be output to console
        public static func debug(_ items: Any..., className: String = #file, line: Int = #line) {
            /* Condition validation: validate debug mode */
            guard
                isLevelEnabled(.debug),
                let message = formatMessage(at: .debug, with: items.map{"\($0)"}, className: className, line: line)
            else {
                return
            }
            DDLogDebug(message)
        }

        /// Log verbose message.
        ///
        /// - Parameters:
        ///   - items: list of items to be output to console
        public static func verbose(_ items: Any..., className: String = #file, line: Int = #line) {
            /* Condition validation: validate debug mode */
            guard
                isLevelEnabled(.verbose),
                let message = formatMessage(at: .verbose, with: items.map{"\($0)"}, className: className, line: line)
            else {
                return
            }

            DDLogVerbose(message)
        }

        /// Struct's private properties.
        private static var logLevel: DDLogLevel = .debug
    }

    // MARK: Struct's private func.
    private extension FwiLog {
        private static func formatMessage(at level: DDLogLevel, with items: [String], className: String, line: Int) -> String? {
            /* Condition validation: validate class's name */
            let tokens = className.split("/")
            guard let name = tokens.last, name.count > 0 else {
                return nil
            }

            let parts = items.map { String(describing: $0) }
            let message = parts.joined(separator: ", ")

            switch level {
            case .error:
                return String(format: "[ERROR] <%@ %i>: %@", name, line, message)
            case .warning:
                return String(format: "[WARNING] <%@ %i>: %@", name, line, message)
            case .info:
                return String(format: "[INFO] <%@ %i>: %@", name, line, message)
            default:
                return String(format: "[DEBUG] <%@ %i>: %@", name, line, message)
            }
        }

        private static func isLevelEnabled(_ levelCheck: DDLogLevel) -> Bool {
            let result = logLevel.rawValue & levelCheck.rawValue
            return (result == levelCheck.rawValue)
        }
    }
#endif
