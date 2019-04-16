import RxSwift
//  File name   : DraggableViewProtocol.swift
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

#if canImport(UIKit)
    import UIKit

    public enum DraggableDirection {
        case down
        case left
    }

    public protocol DraggableViewProtocol: AnyObject, DisposableProtocol, ContainerViewProtocol, DismissProtocol {
        var panGesture: UIPanGestureRecognizer? { get }
    }

    public extension DraggableViewProtocol {
        /// Setup draggable event for container view.
        ///
        /// - Parameter direction: draggable direction
        func setupDraggable(direction: DraggableDirection = .down) {
            panGesture?.rx.event.bind(onNext: { [weak self] g in
                guard let wSelf = self, let container = wSelf.containerView else {
                    return
                }

                defer { g.setTranslation(.zero, in: container) }

                switch direction {
                case .down:
                    wSelf.down(from: g, in: container)

                case .left:
                    wSelf.left(from: g, in: container)
                }
            })
                .disposed(by: disposeBag)
        }

        private func down(from gesture: UIPanGestureRecognizer, in container: UIView) {
            let state = gesture.state
            switch state {
            case .changed:
                let translation = gesture.translation(in: container)
                let current = container.transform
                let next = current.ty + translation.y
                guard next > 0 else {
                    container.transform = .identity
                    return
                }
                container.transform = current.translatedBy(x: 0, y: translation.y)

            case .ended:
                let deltaY = container.transform.ty
                guard deltaY >= container.bounds.height / 2 else {
                    container.transform = .identity
                    return
                }
                dismiss()

            default:
                break
            }
        }

        private func left(from gesture: UIPanGestureRecognizer, in container: UIView) {
            let state = gesture.state
            switch state {
            case .changed:
                let translation = gesture.translation(in: container)
                let current = container.transform
                let next = current.tx + translation.x
                guard next < 0 else {
                    container.transform = .identity
                    return
                }
                container.transform = current.translatedBy(x: translation.x, y: 0)

            case .ended:
                let deltaX = container.transform.tx
                guard abs(deltaX) >= container.bounds.width / 2 else {
                    container.transform = .identity
                    return
                }
                dismiss()

            default:
                break
            }
        }
    }
#endif
