//  File name   : GenericTableViewVM.swift
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


open class GenericTableViewVM<T>: TableViewVM {

    // MARK: Class's properties
    public let currentItemSubject = ReplaySubject<T?>.create(bufferSize: 1)
    public fileprivate(set) var currentItem: T? = nil {
        didSet {
            currentItemSubject.on(.next(currentItem))
        }
    }
    internal var items: ArraySlice<T>?
    
    // MARK: UITableViewDataSource's members
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }

    open override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        currentItem = self[indexPath]
    }
    open override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        currentItem = nil
    }
}

// MARK: Class's subscript
extension GenericTableViewVM {
    
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
