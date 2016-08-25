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
    public class func reflectedImageWithView(_ view: UIView, imageHeight height: CGFloat) -> UIImage? {
        let imgHeight = Int(round(height))
        let imgWidth = Int(round(view.bounds.width))
        let colors: [CGFloat] = [0.0, 1.0, 1.0, 1.0]

        // create a bitmap graphics context the size of the image
        let bitmapInfoRaw = CGBitmapInfo.byteOrder32Little.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue))
        let colorSpace1 = CGColorSpaceCreateDeviceRGB()
        let colorSpace2 = CGColorSpaceCreateDeviceGray()
        if let
            image = view.createImage(),
            let grayscaleGradient = CGGradient(colorSpace: colorSpace2, colorComponents: colors, locations: nil, count: 2),
            let mainContext = CGContext(data: nil, width: imgWidth, height: imgHeight, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace1, bitmapInfo: bitmapInfoRaw.rawValue) {
            // Create a 1 pixel wide gradient
            let bitmapInfoRawGradient = CGBitmapInfo.alphaInfoMask.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue))
            let gradientContext = CGContext(data: nil, width: imgWidth, height: imgHeight, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace2, bitmapInfo: bitmapInfoRawGradient.rawValue)

            // Draw the gradient into the gray bitmap context
            let gradientStart = CGPoint.zero
            let gradientEnd = CGPoint(x: 0.0, y: CGFloat(imgHeight))
            gradientContext?.drawLinearGradient(grayscaleGradient, start: gradientStart, end: gradientEnd, options: CGGradientDrawingOptions.drawsAfterEndLocation)

            // Convert the context into a CGImageRef
            guard let imgGradientRef = gradientContext?.makeImage() else {
                return nil
            }

            // Create an image by masking the bitmap
            mainContext.clip(to: CGRect(x: 0.0, y: 0.0, width: CGFloat(imgWidth), height: CGFloat(imgHeight)), mask: imgGradientRef)

            // In order to grab the part of the image that we want to render, we move the context origin  to the height of the image
            mainContext.translateBy(x: 0.0, y: height)
            mainContext.scaleBy(x: 1.0, y: -1.0)

            // Draw the image into the bitmap context
            guard let imageCGI = image.cgImage  else {
                return nil
            }
            mainContext.draw(imageCGI, in: view.bounds)
            
            // Create CGImageRef
            guard let imgReflectedRef = mainContext.makeImage() else {
                return nil
            }

            // Convert to UIImage
            return UIImage(cgImage: imgReflectedRef)
        } else {
            return nil
        }
    }

    /** Create blur effect image from original source. */
    public func darkBlur(_ radius: CGFloat = 20.0, saturationFactor saturation: CGFloat = 1.9) -> UIImage {
        let tintColor = UIColor(white: 0.1, alpha: 0.5)
        return self.generateBlurImage(radius, tintColor: tintColor, saturationFactor: saturation)
    }
    public func lightBlur(_ radius: CGFloat = 20.0, saturationFactor saturation: CGFloat = 1.9) -> UIImage {
        let tintColor = UIColor(white: 1.0, alpha: 0.5)
        return self.generateBlurImage(radius, tintColor: tintColor, saturationFactor: saturation)
    }

    public func generateBlurImage(_ blurRadius: CGFloat, tintColor tint: UIColor, saturationFactor s: CGFloat) -> UIImage {
        let imageRect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        var effectImage = self

        /* Condition validation: Validate against zero */
        let hasBlur = (blurRadius > CGFloat(FLT_EPSILON))
        let hasSaturation = (fabs(s - 1.0) > CGFloat(FLT_EPSILON))
        // Draw this image on effect input context
        
        guard let imageCGI = self.cgImage else {
            return UIImage()
        }
        
        if hasBlur || hasSaturation {
            /** Effect Input Context */
            UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
            let inputContext = UIGraphicsGetCurrentContext()

            inputContext?.scaleBy(x: 1.0, y: -1.0)
            inputContext?.translateBy(x: 0.0, y: -self.size.height)
            inputContext?.draw(imageCGI, in: imageRect)
            
            // Capture image from input context to input buffer
            var inputBuffer = vImage_Buffer(data: inputContext?.data,
                                            height: vImagePixelCount((inputContext?.height)!),
                                            width: vImagePixelCount((inputContext?.width)!),
                                            rowBytes: (inputContext?.bytesPerRow)!)

            /** Effect Output Context */
            UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
            let outputContext = UIGraphicsGetCurrentContext()

            // Prepare output buffer
            var outputBuffer = vImage_Buffer(data: outputContext?.data,
                height: vImagePixelCount((outputContext?.height)!),
                width: vImagePixelCount((outputContext?.width)!),
                rowBytes: (outputContext?.bytesPerRow)!)

            // Apply blur if required
            if hasBlur {
                func calculateRadius() -> UInt32{
                    let result = blurRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5
                    return UInt32(floor(result))
                }
                
                
                var radius = calculateRadius()

                /* Condition validation: Three box-blur methodology require odd radius */
                if (radius % 2) != 1 {
                    radius += 1
                }

                vImageBoxConvolve_ARGB8888(&inputBuffer, &outputBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&outputBuffer, &inputBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&inputBuffer, &outputBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
            }

            var isSwapped = false
            if hasSaturation {
                var saturationMatrixf = [0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
                    0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
                    0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
                    0, 0, 0, 1]

                // Convert saturation matrix from float to 8Bits value
                let divisor: Int32 = 256
                var saturationMatrix = [Int16](repeating: 0, count: saturationMatrixf.count)

                for i in 0 ..< saturationMatrixf.count {
                    saturationMatrix[i] = Int16(roundf(Float(saturationMatrixf[i]) * Float(divisor)))
                }

                // Apply blur effect
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&outputBuffer, &inputBuffer, saturationMatrix, divisor, nil, nil, vImage_Flags(kvImageNoFlags))
                    isSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&inputBuffer, &outputBuffer, saturationMatrix, divisor, nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }

            if !isSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            UIGraphicsEndImageContext()

            if isSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            UIGraphicsEndImageContext()
        }

        guard let effectCGI = effectImage.cgImage else {
            return UIImage()
        }
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let outputContext = UIGraphicsGetCurrentContext()

        outputContext?.scaleBy(x: 1.0, y: -1.0)
        outputContext?.translateBy(x: 0.0, y: -self.size.height)
        
        // Draw base image.
        outputContext?.draw(imageCGI, in: imageRect)
        
        
        // Draw blur image.
        if (hasBlur) {
            outputContext?.saveGState()
            outputContext?.draw(effectCGI, in: imageRect)
            outputContext?.restoreGState()
        }

        // Add tint color
        outputContext?.saveGState()
        outputContext?.setFillColor(tint.cgColor)
        outputContext?.fill(imageRect)
        outputContext?.restoreGState()

        // Output result
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return outputImage ?? UIImage()
    }
}
