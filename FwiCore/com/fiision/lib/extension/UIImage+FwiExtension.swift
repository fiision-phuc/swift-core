//  Project name: FwiCore
//  File name   : UIImage+FwiExtension.swift
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
import Accelerate
import CoreGraphics

public extension UIImage {

    /** Create a reflected image for specific view. */
    public class func reflectedImageWithView(view: UIView?, imageHeight height: CGFloat) -> UIImage? {
        /* Condition validation */
        if (view == nil || height == 0.0) {
            return nil
        }
        let imgWidth = Int(round(CGRectGetWidth(view!.bounds)))
        let imgHeight = Int(round(height))

        // create a bitmap graphics context the size of the image
        var colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmapInfoRaw = CGBitmapInfo.ByteOrder32Little.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue))
        let mainContext = CGBitmapContextCreate(nil, imgWidth, imgHeight, 8, 0, colorSpace, bitmapInfoRaw.rawValue)

        // Create a 1 pixel wide gradient
        colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfoRawGradient = CGBitmapInfo.AlphaInfoMask.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue))
        let gradientContext = CGBitmapContextCreate(nil, imgWidth, imgHeight, 8, 0, colorSpace, bitmapInfoRawGradient.rawValue)

        // Create the CGGradient
        let colors: [CGFloat] = [0.0, 1.0, 1.0, 1.0]
        let grayscaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, nil, 2)

        // Draw the gradient into the gray bitmap context
        let gradientStart = CGPoint.zero
        let gradientEnd = CGPointMake(0.0, CGFloat(imgHeight))
        CGContextDrawLinearGradient(gradientContext, grayscaleGradient, gradientStart, gradientEnd, CGGradientDrawingOptions.DrawsAfterEndLocation)

        // Convert the context into a CGImageRef
        let imgGradientRef = CGBitmapContextCreateImage(gradientContext)

        // Create an image by masking the bitmap
        CGContextClipToMask(mainContext, CGRectMake(0.0, 0.0, CGFloat(imgWidth), CGFloat(imgHeight)), imgGradientRef)

        // In order to grab the part of the image that we want to render, we move the context origin  to the height of the image
        CGContextTranslateCTM(mainContext, 0.0, height)
        CGContextScaleCTM(mainContext, 1.0, -1.0)

        // Draw the image into the bitmap context
        CGContextDrawImage(mainContext, view!.bounds, view!.createImage()!.CGImage)

        // Create CGImageRef
        let imgReflectedRef = CGBitmapContextCreateImage(mainContext)

        // Convert to UIImage
        return (imgReflectedRef != nil) ? UIImage(CGImage: imgReflectedRef!) : nil
    }

    /** Create blur effect image from original source. */
    public func darkBlur() -> UIImage? {
        return self.darkBlurWithRadius(20.0, saturationFactor: 1.9)
    }
    public func darkBlurWithRadius(radius: CGFloat, saturationFactor saturation: CGFloat) -> UIImage? {
        let tintColor = UIColor(white: 0.1, alpha: 0.5)
        return self.generateBlurImage(radius, tintColor: tintColor, saturationFactor: saturation)
    }

    public func lightBlur() -> UIImage? {
        return self.lightBlurWithRadius(20.0, saturationFactor: 1.9)
    }
    public func lightBlurWithRadius(radius: CGFloat, saturationFactor saturation: CGFloat) -> UIImage? {
        let tintColor = UIColor(white: 1.0, alpha: 0.5)
        return self.generateBlurImage(radius, tintColor: tintColor, saturationFactor: saturation)
    }

    // MARK: Class's private methods
    public func generateBlurImage(blurRadius: CGFloat, tintColor tint: UIColor?, saturationFactor saturation: CGFloat) -> UIImage {
        let imageRect = CGRectMake(0.0, 0.0, self.size.width, self.size.height)
        var effectImage = self

        /* Condition validation: Validate against zero */
        let hasBlur = (blurRadius > FLT_EPSILON)
        let hasSaturation = (fabs(saturation - 1.0) > FLT_EPSILON)

        if (hasBlur || hasSaturation) {
            /** Effect Input Context */
            UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
            let inputContext = UIGraphicsGetCurrentContext()

            CGContextScaleCTM(inputContext, 1.0, -1.0)
            CGContextTranslateCTM(inputContext, 0.0, -self.size.height)

            // Draw this image on effect input context
            CGContextDrawImage(inputContext, imageRect, self.CGImage)

            // Capture image from input context to input buffer
            var inputBuffer = vImage_Buffer(data: CGBitmapContextGetData(inputContext),
                height: vImagePixelCount(CGBitmapContextGetHeight(inputContext)),
                width: vImagePixelCount(CGBitmapContextGetWidth(inputContext)),
                rowBytes: CGBitmapContextGetBytesPerRow(inputContext))

            /** Effect Output Context */
            UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
            let outputContext = UIGraphicsGetCurrentContext()

            // Prepare output buffer
            var outputBuffer = vImage_Buffer(data: CGBitmapContextGetData(outputContext),
                height: vImagePixelCount(CGBitmapContextGetHeight(outputContext)),
                width: vImagePixelCount(CGBitmapContextGetWidth(outputContext)),
                rowBytes: CGBitmapContextGetBytesPerRow(outputContext))

            // Apply blur if required
            if (hasBlur) {
                var radius = UInt32(floor(blurRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))

                /* Condition validation: Three box-blur methodology require odd radius */
                if ((radius % 2) != 1) {
                    radius += 1
                }

                vImageBoxConvolve_ARGB8888(&inputBuffer, &outputBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&outputBuffer, &inputBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&inputBuffer, &outputBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
            }

            var isSwapped = false
            if (hasSaturation) {
                let s = saturation
                var saturationMatrixf = [0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
                    0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
                    0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
                    0, 0, 0, 1]

                // Convert saturation matrix from float to 8Bits value
                let divisor: Int32 = 256
                var saturationMatrix = [Int16](count: saturationMatrixf.count, repeatedValue: 0)
                for i in 0 ..< saturationMatrixf.count {
                    saturationMatrix[i] = Int16(roundf(Float(saturationMatrixf[i]) * Float(divisor)))
                }

                // Apply blur effect
                if (hasBlur) {
                    vImageMatrixMultiply_ARGB8888(&outputBuffer, &inputBuffer, saturationMatrix, divisor, nil, nil, vImage_Flags(kvImageNoFlags))
                    isSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&inputBuffer, &outputBuffer, saturationMatrix, divisor, nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }

            if (!isSwapped) {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()

            if (isSwapped) {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
        }

        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale)
        let outputContext = UIGraphicsGetCurrentContext()

        CGContextScaleCTM(outputContext, 1.0, -1.0)
        CGContextTranslateCTM(outputContext, 0.0, -self.size.height)

        // Draw base image.
        CGContextDrawImage(outputContext, imageRect, self.CGImage)

        // Draw blur image.
        if (hasBlur) {
            CGContextSaveGState(outputContext)

            CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)

            CGContextRestoreGState(outputContext)
        }

        // Add tint color
        if (tint != nil) {
            CGContextSaveGState(outputContext)

            CGContextSetFillColorWithColor(outputContext, tint!.CGColor)
            CGContextFillRect(outputContext, imageRect)

            CGContextRestoreGState(outputContext)
        }

        // Output result
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
}
