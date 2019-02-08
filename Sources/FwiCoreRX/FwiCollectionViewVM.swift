//  File name   : FwiCollectionViewVM.swift
//
//  Author      : Phuc Tran
//  Created date: 7/14/18
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
    import FwiCore
    import RxCocoa
    import RxSwift
    import UIKit

    open class FwiCollectionViewVM: FwiViewModel {
        /// Class's public properties.
        public var currentOptionalIndexPath: Observable<IndexPath?> {
            return currentIndexPathSubject.asObservable()
        }

        public var currentIndexPath: Observable<IndexPath> {
            return currentIndexPathSubject.asObservable()
                .flatMap { indexPath -> Observable<IndexPath> in
                    guard let indexPath = indexPath else {
                        return Observable<IndexPath>.empty()
                    }
                    return Observable<IndexPath>.just(indexPath)
                }
        }

        public private(set) weak var collectionView: UICollectionView?
        public var isEnableOrdering = false {
            didSet {
                longPressGesture?.isEnabled = isEnableOrdering
            }
        }

        /// Class's constructors.
        public init(with collectionView: UICollectionView?) {
            super.init()
            self.collectionView = collectionView

            if #available(iOS 9.0, *) {
                self.longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(FwiCollectionViewVM.handle(longPressGesture:)))
            }
        }

        // MARK: Class's public methods

        open override func setupRX() {
            collectionView?.rx
                .setDataSource(self)
                .disposed(by: disposeBag)

            collectionView?.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            if #available(iOS 9.0, *) {
                longPressGesture?.isEnabled = isEnableOrdering
                if let gesture = longPressGesture {
                    collectionView?.addGestureRecognizer(gesture)
                }
            }
        }

        /// Deselect item at index
        ///
        /// - Parameter index: item's index
        open func deselect(itemAt index: Int) {
            let indexPath = IndexPath(item: index, section: 0)
            deselect(itemAt: indexPath)
        }

        /// Deselect item at index path
        ///
        /// - Parameter indexPath: item's index path
        open func deselect(itemAt indexPath: IndexPath) {
            guard
                let collectionView = self.collectionView,
                self.collectionView(collectionView, shouldDeselectItemAt: indexPath)
            else {
                return
            }
            self.collectionView(collectionView, didDeselectItemAt: indexPath)
        }

        /// Select item at index
        ///
        /// - Parameters:
        ///   - index: item's index
        ///   - scrollPosition: how to scroll to that item
        open func select(itemAt index: Int, scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally) {
            let indexPath = IndexPath(item: index, section: 0)
            select(itemAt: indexPath, scrollPosition: scrollPosition)
        }

        /// Select item at index path
        ///
        /// - Parameters:
        ///   - indexPath: item's index path
        ///   - scrollPosition: how to scroll to that item
        open func select(itemAt indexPath: IndexPath, scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally) {
            guard let collectionView = self.collectionView else {
                return
            }

            let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            guard 0 <= indexPath.item, indexPath.item < count else {
                return
            }

            collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
            self.collectionView(collectionView, didSelectItemAt: indexPath)
        }

        /// Class's private properties.
        private let currentIndexPathSubject = ReplaySubject<IndexPath?>.create(bufferSize: 1)
        private var longPressGesture: UILongPressGestureRecognizer?
    }

    // MARK: Class's private methods

    private extension FwiCollectionViewVM {
        @available(iOS 9.0, *)
        @objc private func handle(longPressGesture gesture: UILongPressGestureRecognizer) {
            let location = gesture.location(in: gesture.view)

            switch gesture.state {
            case .began:
                guard let indexPath = collectionView?.indexPathForItem(at: location) else {
                    break
                }
                collectionView?.beginInteractiveMovementForItem(at: indexPath)

            case .changed:
                collectionView?.updateInteractiveMovementTargetPosition(location)

            case .ended:
                collectionView?.endInteractiveMovement()

            default:
                collectionView?.cancelInteractiveMovement()
            }
        }
    }

    // MARK: UICollectionViewDataSource's members

    extension FwiCollectionViewVM: UICollectionViewDataSource {
        open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            fatalError("Child class should override func \(#function)")
        }

        open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            fatalError("Child class should override func \(#function)")
        }

        /// Moving/reordering
        @available(iOS 9.0, *)
        open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
            return true
        }

        /// Index.
        open func indexTitles(for collectionView: UICollectionView) -> [String]? {
            return nil
        }

        open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
            return IndexPath(item: 0, section: 0)
        }

        /// Data manipulation - reorder / moving support.
        @available(iOS 9.0, *)
        open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
    }

    // MARK: UICollectionViewDelegate's members

    extension FwiCollectionViewVM: UICollectionViewDelegate {
        /// Display customization.
        open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}

        open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}

        open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {}

        open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {}

        /// Selection.
        open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
            return true
        }

        open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {}

        open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {}

        open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            return true
        }
        open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            currentIndexPathSubject.on(.next(indexPath))
        }

        public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
            return true
        }
        public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            currentIndexPathSubject.bind(onNext: { [weak self] currentIndex in
                guard let currentIndex = currentIndex, currentIndex == indexPath else {
                    return
                }
                self?.currentIndexPathSubject.on(.next(nil))
            })
                .dispose()
        }

        /// Moving/reordering
        @available(iOS 9.0, *)
        open func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
            return proposedIndexPath
        }

        /// Copy/Paste. All three methods must be implemented by the delegate.
        open func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
            return false
        }

        open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
            return false
        }

        open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {}
    }

    // MARK: UICollectionViewDelegateFlowLayout's members

    extension FwiCollectionViewVM: UICollectionViewDelegateFlowLayout {
        open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            fatalError("Child class should override func \(#function)")
        }

        open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10.0
        }

        open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10.0
        }
    }
#endif
