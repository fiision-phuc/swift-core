//  File name   : GenericCollectionViewVM.swift
//
//  Author      : Phuc Tran
//  Created date: 7/15/18
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2018 Aversafe. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import Foundation

#if canImport(RxSwift) && canImport(FwiCore) && canImport(FwiCoreRX)
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
