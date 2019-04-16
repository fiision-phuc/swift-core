//  File name   : UIView+Extension.swift
//
//  Author      : Phuc, Tran Huu
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

#if canImport(UIKit) && (os(iOS) || os(tvOS))
    import UIKit

    @IBDesignable
    public extension UIView {
        @IBInspectable
        var borderColor: UIColor? {
            get {
                if let color = layer.borderColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set(color) {
                if let color = color {
                    layer.borderColor = color.cgColor
                }
                layer.borderColor = nil
            }
        }

        @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set(borderWidth) {
                layer.borderWidth = borderWidth
            }
        }

        @IBInspectable
        var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set(radius) {
                let bgLayer = self.layer
                bgLayer.cornerRadius = radius
                bgLayer.masksToBounds = (radius > 0)
            }
        }

        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set(color) {
                if let color = color {
                    layer.shadowColor = color.cgColor
                }
                layer.shadowColor = nil
            }
        }

        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set(shadowOffset) {
                layer.shadowOffset = shadowOffset
            }
        }

        @IBInspectable
        var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set(shadowOpacity) {
                layer.shadowOpacity = shadowOpacity
            }
        }

        @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set(shadowRadius) {
                layer.shadowRadius = shadowRadius
            }
        }
    }

    public extension UIView {
        /// Create image from current view.
        func createImage(_ scaleFactor: CGFloat = UIScreen.main.scale) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scaleFactor)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }

            // Translate graphic context to offset before render if view is table view
            if let tableView = self as? UITableView {
                let contentOffset = tableView.contentOffset
                context.translateBy(x: contentOffset.x, y: -contentOffset.y)
            }
            layer.render(in: context)

            // Create image
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }

        /// Create image from region of interest.
        func createImageWithROI(_ roiRect: CGRect, scaleFactor scale: CGFloat = UIScreen.main.scale) -> UIImage? {
            /* Condition validation: Validate ROI */
            if !self.bounds.contains(roiRect) {
                return nil
            }

            UIGraphicsBeginImageContextWithOptions(roiRect.size, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }

            context.translateBy(x: -roiRect.origin.x, y: -roiRect.origin.y)
            layer.render(in: context)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }

        /// Find first responder within tree views.
        func findFirstResponder() -> UIView? {
            /* Condition validation */
            if self.isFirstResponder {
                return self
            }

            // Find and resign first responder
            for view in self.subviews {
                if view.isFirstResponder {
                    return view
                } else {
                    guard let nView = view.findFirstResponder() else {
                        continue
                    }
                    return nView
                }
            }
            return nil
        }

        /// Find and resign first responder within tree views.
        func findAndResignFirstResponder() {
            self.findFirstResponder()?.resignFirstResponder()
        }
    }
#endif
