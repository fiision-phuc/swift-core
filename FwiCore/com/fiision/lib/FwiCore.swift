//  Project name: FwiCore
//  File name   : FwiCore.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/20/14
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

import UIKit
import Foundation


// Degree/Radians Values
public let FLT_EPSILON: CGFloat = 1.19209e-07

public let Metric_DegreeToRadian: Double = 0.0174532925199432957
public let Metric_RadianToDegree: Double = 57.295779513082320876
public let Metric_Circle: Float = 6.28319 // (360 degree)

// Log Function
public func FwiLog(className: String = #file, methodName: String = #function, line: Int = #line, message: String?) {
    #if DEBUG
        let name = className.componentsSeparatedByString("/").last
        
        if name != nil && name?.isEmpty != true {
            if message != nil && message?.isEmpty != true {
                print("\(name!) > \(methodName)[\(NSDate()) \(line)]: \(message!)")
            }
            else {
                print("\(name!) > \(methodName)[\(NSDate()) \(line)]")
            }
        }
        else {
            if message != nil && message?.isEmpty != true {
                print("\(methodName)[\(NSDate()) \(line)]: \(message!)")
            } else {
                print("\(methodName)[\(NSDate()) \(line)]")
            }
        }
    #endif
}

// Metric Functions
public func FwiConvertToDegree(radianValue radian: Double) -> Double {
    let degree = radian * Metric_RadianToDegree
    return degree
}
public func FwiConvertToRadian(degreeValue degree: Double) -> Double {
    let radian = degree * Metric_DegreeToRadian
    return radian
}
