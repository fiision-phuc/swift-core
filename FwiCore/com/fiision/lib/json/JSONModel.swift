//  Project name: ZinioReader
//  File name   : JSONModel.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 6/10/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Zinio Pro. All rights reserved.
//  --------------------------------------------------------------

import Foundation


@objc
public protocol JSONModel: NSObjectProtocol {

    /** Define key mapper. */
    optional func keyMapper() -> [String: String]

    /** Validate if property is optional or not. */
    optional func propertyIsOptional() -> [String]

    /** Validate if property should be ignored or not. */
    optional func propertyIsIgnored(propertyName: String) -> Bool
}
