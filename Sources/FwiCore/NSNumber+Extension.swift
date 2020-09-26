//  File name   : NSNumber+Extension.swift
//
//  Author      : Phuc, Tran Huu
//  Editor      : Dung Vu
//  Created date: 11/22/14
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

public extension NSNumber {
    /// Display number to specific currency format.
    ///
    /// - Parameters:
    ///   - iso3: currency's ISO3
    ///   - decimalSeparator: decimal's separator (ex. xxx.xx)
    ///   - groupingSeparator: grouping's separator (ex. xxx,xxx)
    ///   - usingSymbol: currency display ($100.00 vs. 100.00 USD)
    ///   - placeSymbolFront: currency display ($100.00 vs. 100.00$)
    func currency(_ iso3: String,
                  decimalSeparator: String = ".",
                  groupingSeparator: String = ",",
                  usingSymbol: Bool = true,
                  placeSymbolInFront: Bool = true) -> String?
    {
        // Initialize currency format object
        let locale = Locale(identifier: "en_US")
        let currencyFormat = NumberFormatter()

        // Layout currency
        currencyFormat.formatterBehavior = NumberFormatter.Behavior.behavior10_4
        currencyFormat.generatesDecimalNumbers = false
        currencyFormat.numberStyle = .currency
        currencyFormat.roundingMode = .halfUp
        currencyFormat.locale = locale

        currencyFormat.currencyDecimalSeparator = decimalSeparator
        currencyFormat.currencyGroupingSeparator = groupingSeparator
        if usingSymbol {
            currencyFormat.positiveFormat = placeSymbolInFront ? "\u{00a4}#,##0.00" : "#,##0.00\u{00a4}"
            currencyFormat.negativeFormat = placeSymbolInFront ? "- \u{00a4}#,##0.00" : "- #,##0.00\u{00a4}"
        } else {
            currencyFormat.positiveFormat = "#,##0.00 \(iso3)"
            currencyFormat.negativeFormat = "- #,##0.00 \(iso3)"
        }
        currencyFormat.currencyCode = iso3

        // Return result
        return currencyFormat.string(from: self)
    }
}
