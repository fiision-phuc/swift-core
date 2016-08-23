//  Project name: FwiCore
//  File name   : NSNumber+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/22/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2012, 2016 Fiision Studio.
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


public extension NSNumber {

    /** Display number to specific currency format. */
    public func currencyWithISO3(_ currencyISO3: String, decimalSeparator decimal: String, groupingSeparator grouping: String, usingSymbol isSymbol: Bool) -> String? {
        // Initialize currency format object
        let locale = NSLocale(localeIdentifier: "en_US")
        let currencyFormat = NumberFormatter()

        // Layout currency
        currencyFormat.formatterBehavior = NumberFormatter.Behavior.behavior10_4
        currencyFormat.roundingMode = NumberFormatter.RoundingMode.halfUp
        currencyFormat.numberStyle = NumberFormatter.Style.currency

        currencyFormat.generatesDecimalNumbers = true
        currencyFormat.locale = locale as Locale!

        currencyFormat.currencyGroupingSeparator = grouping
        currencyFormat.currencyDecimalSeparator = decimal

        if isSymbol {
            currencyFormat.positiveFormat = "\u{00a4}#,##0.00"
            currencyFormat.negativeFormat = "- \u{00a4}#,##0.00"
        } else {
            currencyFormat.positiveFormat = "#,##0.00 \(currencyISO3)"
            currencyFormat.negativeFormat = "- #,##0.00 \(currencyISO3)"
        }
        currencyFormat.currencyCode = currencyISO3

        // Return result
        return currencyFormat.string(from: self)
    }
}
