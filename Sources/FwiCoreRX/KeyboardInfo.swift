//  File name   : KeyboardInfo.swift
//
//  Author      : Dung Vu
//  Created date: 2/7/19
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

#if canImport(UIKit) && os(iOS)
    import UIKit

    public struct KeyboardInfo {
        /// Struct's public properties.
        public let hidden: Bool
        public let height: CGFloat
        public let remainHeight: CGFloat
        public let animationDuration: TimeInterval

        /// Struct's constructors.
        public init?(_ notification: Notification) {
            guard let userInfo = notification.userInfo else {
                return nil
            }

            animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval) ?? 0
            hidden = (notification.name == UIResponder.keyboardWillHideNotification)

            height = hidden ? 0 : ((userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0)
            remainHeight = UIScreen.main.bounds.height - height
        }

        // MARK: - Struct's public methods
        public func animate(view: UIView?) {
            if hidden {
                UIView.animate(withDuration: animationDuration) {
                    /* Condition validation: check if it is scrollview, then we only need to change inset, otherwise we apply transform */
                    guard let scrollView = view as? UIScrollView else {
                        view?.transform = CGAffineTransform.identity
                        return
                    }
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
            } else {
                guard
                    let containerView = view,
                    let firstResponderView = containerView.findFirstResponder()
                else { return }

                let firstResponderViewCenterY = firstResponderView.frame.midY
                let remainCenterY = round(remainHeight / 2)

                // Calculate adjustment height
                var h = firstResponderViewCenterY - remainCenterY
                var containerViewFrame = containerView.frame
                containerViewFrame.origin.y -= h

                /* Condition validation: validate container view's top margin */
                if containerViewFrame.minY > 0 {
                    h += (containerViewFrame.minY - 0)
                }

                /* Condition validation: validate container view's bottom margin */
                if containerViewFrame.maxY < remainHeight {
                    h -= (remainHeight - containerViewFrame.maxY)
                }

                let transfrom = CGAffineTransform(translationX: 0, y: -h)
                UIView.animate(withDuration: animationDuration) {
                    /* Condition validation: check if it is scrollview, then we only need to change inset, otherwise we apply transform */
                    guard let scrollView = view as? UIScrollView else {
                        view?.transform = transfrom
                        return
                    }
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: h, right: 0)
                }
            }
        }
    }
#endif
