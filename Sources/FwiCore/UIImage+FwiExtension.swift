//  File name   : UIImage+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/22/14
//  --------------------------------------------------------------
//  Copyright © 2012, 2018 Fiision Studio. All Rights Reserved.
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

#if canImport(UIKit)
    import UIKit

    public extension UIImage {
        /// Create circular image from original image with specific size.
        ///
        /// - Parameters:
        ///   - size {CGFloat} (the circular image's diameter)
        public func circularImage(withSize size: CGFloat) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, UIScreen.main.scale)
            let rect = CGRect(x: 0, y: 0, width: size, height: size)

            UIBezierPath(roundedRect: rect, cornerRadius: (rect.width / 2)).addClip()
            draw(in: rect)

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }

        /// Create circular image from original image with specific size and badge.
        ///
        /// - Parameters:
        ///   - size {CGFloat} (the circular image's diameter)
        public func circularImage(withSize size: CGFloat, point p: CGPoint, radius r: CGFloat = 2) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, UIScreen.main.scale)
            let rect = CGRect(x: 0, y: 0, width: size, height: size)
            let ctx = UIGraphicsGetCurrentContext()!

            // Draw circular
            ctx.saveGState()
            UIBezierPath(roundedRect: rect, cornerRadius: (rect.width / 2)).addClip()
            draw(in: rect)
            ctx.restoreGState()

            ctx.saveGState()
            UIColor.red.setFill()
            ctx.fillEllipse(in: CGRect(x: p.x, y: p.y, width: r * 2, height: r * 2))
            ctx.saveGState()

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }
    }
#endif
