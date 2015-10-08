//  Project name: FwiCore
//  File name   : FwiExtensionNumberTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/27/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


class FwiExtensionNumberTest: XCTestCase {

    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }

    
    // MARK: Test Cases
    func testCurrency() {
        var currencyNumber = NSNumber(float: 2000)
        
        var currencyString = currencyNumber.currencyWithISO3("USD", decimalSeparator: ".", groupingSeparator: ",", usingSymbol: true)
        XCTAssertEqual(currencyString!, "$2,000.00", "Currency string should be: $2,000.00")
        
        currencyString = currencyNumber.currencyWithISO3("USD", decimalSeparator: ".", groupingSeparator: ",", usingSymbol: false)
        XCTAssertEqual(currencyString!, "2,000.00 USD", "Currency string should be: 2,000.00 USD")
        
        currencyString = currencyNumber.currencyWithISO3("USD", decimalSeparator: ",", groupingSeparator: ".", usingSymbol: true)
        XCTAssertEqual(currencyString!, "$2.000,00", "Currency string should be: $2.000,00")
    }
}
