//  File name   : FwiGenericTableViewVM.swift
//
//  Author      : Phuc Tran
//  Created date: 7/15/18
//  Version     : 1.00
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
    import Foundation
    import RxSwift
    import UIKit

    open class FwiGenericTableViewVM<T: Equatable>: FwiTableViewVM {
        /// Class's public properties
        public var currentItem: Observable<T> {
            return currentItemSubject.asObservable()
        }

        open var items: ArraySlice<T>?

        // MARK: Class's public methods

        open override func select(itemAt indexPath: IndexPath, scrollPosition: UITableView.ScrollPosition = .middle) {
            guard
                0 <= indexPath.row && indexPath.row < count,
                let item = self[indexPath]
            else {
                return
            }
            currentItemSubject.on(.next(item))
            super.select(itemAt: indexPath, scrollPosition: scrollPosition)
        }

        open func select(item: T, scrollPosition: UITableView.ScrollPosition = .middle) {
            if let index = items?.index(where: { $0 == item }) {
                select(itemAt: index, scrollPosition: scrollPosition)
            }
        }

        // MARK: UITableViewDataSource's members

        open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return count
        }

        open override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                items?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        }

        open override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            items?.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        }

        // MARK: UITableViewDelegate's members

        open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            select(itemAt: indexPath)
        }

        /// Class's private properties.
        private let currentItemSubject = ReplaySubject<T>.create(bufferSize: 1)
    }

    // MARK: Class's subscript

    extension FwiGenericTableViewVM {
        open var count: Int {
            return items?.count ?? 0
        }

        open subscript(index: Int) -> T? {
            guard 0 <= index && index < count else {
                return nil
            }
            return items?[index]
        }

        open subscript(index: IndexPath) -> T? {
            guard 0 <= index.row && index.row < count else {
                return nil
            }
            return items?[index.row]
        }
    }
#endif
