//  File name   : GenericVM.swift
//
//  Author      : Dung Vu
//  Created date: 4/23/19
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

#if canImport(RxSwift) && canImport(RxCocoa)
    import FwiCore
    import RxCocoa
    import RxSwift
    import UIKit

    // MARK: - Protocol
    public protocol ReuseableProtocol {
        associatedtype CellType
        associatedtype ObjectType

        func itemSelected<S: ObserverType>(to obsever: S) -> Disposable where S.Element == IndexPath
        func setup<Element>(from source: Observable<[Element]>, block: @escaping (_ view: ObjectType, _ index: Int, _ item: Element) -> CellType) -> Disposable
    }

    public extension ReuseableProtocol where Self: UITableView {
        func setup<Element>(from source: Observable<[Element]>, block: @escaping (UITableView, Int, Element) -> UITableViewCell) -> Disposable {
            return source
                .bind(to: self.rx.items)(block)
        }
    }

    public extension ReuseableProtocol where Self: UICollectionView {
        func setup<Element>(from source: Observable<[Element]>, block: @escaping (UICollectionView, Int, Element) -> UICollectionViewCell) -> Disposable {
            return source.bind(to: self.rx.items)(block)
        }
    }

    extension UITableView: ReuseableProtocol {
        public func itemSelected<S>(to obsever: S) -> Disposable where S: ObserverType, S.Element == IndexPath {
            return self.rx.itemSelected.subscribe(obsever)
        }
    }

    extension UICollectionView: ReuseableProtocol {
        public func itemSelected<S>(to obsever: S) -> Disposable where S: ObserverType, S.Element == IndexPath {
            return self.rx.itemSelected.subscribe(obsever)
        }
    }

    public protocol InjectAccessDataSource {
        associatedtype Element
        associatedtype Index

        var items: Observable<[Element]> { get }
        var selectedItem: Observable<Element?> { get }
        var selectedAtIndex: Observable<Index> { get }
    }

    // MARK: - Main class
    open class GenericReuseVM<T: ReuseableProtocol, E>: InjectAccessDataSource {
        public typealias GenericCell = (_ view: T.ObjectType, _ index: Int, _ item: E) -> T.CellType

        /// Class's public properties.
        open var items: Observable<[E]> {
            return _items.asObservable()
        }

        open var selectedItem: Observable<E?> {
            let items = self._items.value
            return selectedAtIndex.map { items[safe: $0.row] }
        }

        open var selectedAtIndex: Observable<IndexPath> {
            return replaySelectItem.asObserver()
        }

        /// Class's constructors.
        public init(_ view: T, _ source: Observable<[E]>, _ block: @escaping GenericCell) {
            self.view = view
            self.source = source
            self.handlerCell = block
            self.setupRX()
        }

        deinit {
            Log.debug("")
        }

        /// Class's public methods.
        open func setupRX() {
            source.bind(to: _items).disposed(by: disposeBag)
            view.setup(from: self.items.observeOn(MainScheduler.asyncInstance), block: self.handlerCell).disposed(by: disposeBag)
            view.itemSelected(to: self.replaySelectItem).disposed(by: disposeBag)
        }

        /// Class's private properties.
        private let view: T
        private let source: Observable<[E]>
        private let handlerCell: GenericCell

        private lazy var disposeBag = DisposeBag()
        private lazy var _items: BehaviorRelay<[E]> = BehaviorRelay(value: [])
        private lazy var replaySelectItem: ReplaySubject<IndexPath> = ReplaySubject.create(bufferSize: 1)
    }
#endif
