//  File name   : GenericTableViewCellVM.swift
//
//  Author      : Phuc Tran
//  Created date: 7/16/18
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2018 Aversafe. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import Foundation


#if canImport(RxSwift) && canImport(FwiCore) && canImport(FwiCoreRX)
open class GenericTableViewCellVM<C: UITableViewCell, M>: GenericTableViewVM<M> {
    
    // MARK: Class's public methods
    /// Initialize cell at index.
    ///
    /// - Parameters:
    ///   - cell: a UITableView's cell according to index
    ///   - item: an item at index
    open func configure(forCell cell: C, with item: M) {
        fatalError("Child class should override func \(#function)")
    }
    
    // MARK: UITableViewDataSource's members
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = C.dequeueCell(tableView: tableView)
        if let item = self[indexPath] {
            configure(forCell: cell, with: item)
        }
        return cell
    }
}
#endif
