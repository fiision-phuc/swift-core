//  File name   : GenericCollectionViewCellVM.swift
//
//  Author      : Phuc Tran
//  Created date: 7/19/18
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2018 Aversafe. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import Foundation


#if canImport(RxSwift) && canImport(FwiCore) && canImport(FwiCoreRX)
open class GenericCollectionViewCellVM<C: UICollectionViewCell, M>: GenericCollectionViewVM<M> {

    // MARK: Class's public methods
    /// Initialize cell at index.
    ///
    /// - Parameters:
    ///   - cell: a UITableView's cell according to index
    ///   - item: an item at index
    open func configure(forCell cell: C, with item: M) {
        fatalError("Child class should override func \(#function)")
    }

    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = C.dequeueCell(collectionView: collectionView, indexPath: indexPath)
        if let item = self[indexPath] {
            configure(forCell: cell, with: item)
        }
        return cell
    }
}
#endif
