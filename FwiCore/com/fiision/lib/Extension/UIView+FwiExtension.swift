//  Project name: FwiCore
//  File name   : UIView+FwiExtension.swift
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


public extension UIView {

    /** Create image from current view. */
    public func createImage() -> UIImage? {
        return self.createImageWithScaleFactor(UIScreen.mainScreen().scale)
    }
    public func createImageWithScaleFactor(scaleFactor: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scaleFactor)

        // Translate graphic context to offset before render if view is table view
        if let tableView = self as? UITableView {
            let contentOffset = tableView.contentOffset
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), contentOffset.x, -contentOffset.y)
        }

        // Render view
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)

        // Create image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /** Create image from region of interest. */
    public func createImageWithROI(roiRect: CGRect) -> UIImage? {
        /* Condition validation: Validate ROI */
        if (!CGRectContainsRect(self.bounds, roiRect)) {
            return nil
        }
        return self.createImageWithROI(roiRect, scaleFactor: UIScreen.mainScreen().scale)
    }
    public func createImageWithROI(roiRect: CGRect, scaleFactor scale: CGFloat) -> UIImage? {
        /* Condition validation: Validate ROI */
        if (!CGRectContainsRect(self.bounds, roiRect)) {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(roiRect.size, false, scale)

        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -roiRect.origin.x, -roiRect.origin.y)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /** Find first responder within tree views. */
    public func findFirstResponder() -> UIView? {
        /* Condition validation */
        if (self.isFirstResponder()) {
            return self
        }

        // Find and resign first responder
        for view in self.subviews {
            if (view.isFirstResponder()) {
                return view
            } else {
                return view.findFirstResponder()
            }
        }

        return nil
    }

    /** Find and resign first responder within tree views. */
    public func findAndResignFirstResponder() {
        if (self.isFirstResponder()) {
            self.resignFirstResponder()
        } else {
            let firstResponder = self.findFirstResponder()
            firstResponder?.resignFirstResponder()
        }
    }

    /** Round corner of an UIView with specific radius. */
    public func roundCorner(radius: CGFloat) {
        let bgLayer = self.layer
        bgLayer.masksToBounds = true
        bgLayer.cornerRadius  = radius
    }
}
