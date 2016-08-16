//  Project name: FwiCore
//  File name   : UIButton+FwiExtension.swift
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

import UIKit
import Foundation


public extension UIButton {

    /** Apply background to button. */
    public func applyBackgroundImage(imageName: String, withEdgeInsets edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)) {
        let imageDefault = UIImage(named: "\(imageName)_Default")?.resizableImageWithCapInsets(edgeInsets)
        let imageHighlighted = UIImage(named: "\(imageName)_Highlighted")?.resizableImageWithCapInsets(edgeInsets)
        let imageSelected = UIImage(named: "\(imageName)_Selected")?.resizableImageWithCapInsets(edgeInsets)
        let imageDisabled = UIImage(named: "\(imageName)_Disabled")?.resizableImageWithCapInsets(edgeInsets)

        self.setImage(imageDefault, forState: UIControlState.Normal)
        self.setImage(imageHighlighted, forState: UIControlState.Highlighted)
        self.setImage(imageSelected, forState: UIControlState.Selected)
        self.setImage(imageDisabled, forState: UIControlState.Disabled)
    }

    /** Apply image to button. */
    public func applyImage(imageName: String) {
        let imageDefault = UIImage(named: "\(imageName)_Default")
        let imageHighlighted = UIImage(named: "\(imageName)_Highlighted")
        let imageSelected = UIImage(named: "\(imageName)_Selected")
        let imageDisabled = UIImage(named: "\(imageName)_Disabled")

        self.setImage(imageDefault, forState: UIControlState.Normal)
        self.setImage(imageHighlighted, forState: UIControlState.Highlighted)
        self.setImage(imageSelected, forState: UIControlState.Selected)
        self.setImage(imageDisabled, forState: UIControlState.Disabled)
    }
}
