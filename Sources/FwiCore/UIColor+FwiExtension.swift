//  Project name: FwiCore
//  File name   : UIColor+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 6/13/16
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

#if os(iOS)
import UIKit


public extension UIColor {

    /// Convert hex to color.
    public convenience init(rgb hex: UInt32) {
        self.init(red: CGFloat((hex & 0xff0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00ff00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000ff) / 255.0,
                  alpha: CGFloat(1.0))
    }
    public convenience init(rgba hex: UInt32) {
        self.init(red: CGFloat((hex & 0xff000000) >> 24) / 255.0,
                  green: CGFloat((hex & 0x00ff0000) >> 16) / 255.0,
                  blue: CGFloat((hex & 0x0000ff00) >> 8) / 255.0,
                  alpha: CGFloat(hex & 0x000000ff) / 255.0)
    }
}
#endif
