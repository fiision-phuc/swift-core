//  Project name: FwiCore
//  File name   : GenericCollectionViewVM.swift
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
import UIKit
import Foundation

#if !RX_NO_MODULE
    import RxSwift
#endif


open class GenericCollectionViewVM<T>: CollectionViewVM {
    
    // MARK: Class's properties
    public let currentItemSubject = ReplaySubject<T?>.create(bufferSize: 1)
    public fileprivate(set) var currentItem: T? = nil {
        didSet {
            currentItemSubject.on(.next(currentItem))
        }
    }
    internal var items: ArraySlice<T>?
    
    // MARK: UICollectionViewDataSource's members
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }

    open override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        items?.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }

    // MARK: UICollectionViewDelegate's members
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentItem = self[indexPath]
    }
    open override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        currentItem = nil
    }
}

// MARK: Class's subscript
extension GenericCollectionViewVM {
    
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
