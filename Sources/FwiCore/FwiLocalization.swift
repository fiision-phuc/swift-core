//  Project name: FwiCore
//  File name   : FwiLocalization.swift
//
//  Author      : Phuc Tran
//  Created date: 4/13/15
//  --------------------------------------------------------------
//  Copyright © 2012, 2017 Fiision Studio. All Rights Reserved.
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


public var FwiCurrentLocale: String {
    get {
        return sharedInstance.locale
    }
    set {
        sharedInstance.locale = newValue
    }
}

/// Localize string for string. The original string will be returned if a localized string could not
/// be found.
///
/// @params:
/// - string {String} (an original string)
public func FwiLocalized(forString s: String?) -> String {
    guard let text = s else {
        return ""
    }
    return sharedInstance.localized(forString: text)
}

/// Reset current locale to english.
public func FwiResetLocale() {
    sharedInstance.reset()
}


fileprivate var sharedInstance = FwiLocalization()
fileprivate struct FwiLocalization {

    
    // MARK: Class's constructors
    fileprivate init() {
        reset()
    }

    // MARK: Class's properties
    fileprivate var locale: String = "en" {
        didSet {
            guard let path = Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: locale) else {
                reset()
                return
            }
            let userDefaults = UserDefaults.standard
            
            userDefaults.set([locale], forKey: "AppleLanguages")
            userDefaults.synchronize()
            
            bundle = Bundle(path: (path as NSString).deletingLastPathComponent)
        }
    }
    fileprivate var bundle: Bundle?
    
    // MARK: Class's public methods
    fileprivate func localized(forString s: String) -> String {
        if let localized = bundle?.localizedString(forKey: s, value: s, table: nil) {
            return localized
        }
        return s
    }

    fileprivate mutating func reset() {
        let languages = Bundle.main.preferredLocalizations
        locale = languages.count > 0 ? languages[0] : "en"
    }
}
