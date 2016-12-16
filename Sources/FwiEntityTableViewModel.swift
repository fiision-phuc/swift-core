//  Project name: FwiCore
//  File name   : FwiEntityTableViewModel.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/4/16
//  Version     : 1.1.0
//  --------------------------------------------------------------
//  Copyright © 2012, 2017 Fiision Studio.
//  All Rights Reserved.
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

#if os(iOS)
import UIKit
import Foundation
import CoreData


public final class FwiEntityTableViewModel<T: NSFetchRequestResult> : FwiEntityViewModel<T>, UITableViewDataSource, UITableViewDelegate {
    public typealias CellFactory = (UITableView, IndexPath, T) -> UITableViewCell
    
    
    /// MARK: Class's constructors
    public convenience init(tableView t: UITableView?, context c: NSManagedObjectContext?) {
        self.init(c)
        self.tableView = t
    }
    
    /// MARK: Class's properties
    public var cellFactory: CellFactory?
    fileprivate weak var tableView: UITableView?
    
    /// MARK: Class's private methods
    internal override func performFetch() {
        super.performFetch()
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource's members
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount()
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCount(forSection: section)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cellFactory = cellFactory, let item = item(forIndexPath: indexPath) else {
            return UITableViewCell()
        }
        return cellFactory(tableView, indexPath, item)
    }
    
    // MARK: UITableViewDelegate's members
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard  let cellFactory = cellFactory, let item = item(forIndexPath: indexPath) else {
            return 45.0
        }
        let cell = cellFactory(tableView, indexPath, item)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return fmax(size.height, 45.0)
    }
    
    /// MARK: NSFetchedResultsControllerDelegate's members
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let flag = delegate?.shouldHandle(entityViewModel: self, deleteArrays: deleteArrays, insertArrays: insertArrays, reloadArrays: reloadArrays) ?? false
        if flag {
            deleteArrays = nil
            insertArrays = nil
            reloadArrays = nil
        } else {
            DispatchQueue.main.async { [weak self] in
                if let array = self?.reloadArrays, array.count > 0 {
                    self?.tableView?.reloadRows(at: array, with:.fade)
                }
                if let array = self?.deleteArrays, array.count > 0 {
                    self?.tableView?.deleteRows(at: array, with: .fade)
                }
                if let array = self?.insertArrays, array.count > 0 {
                    self?.tableView?.insertRows(at: array, with: .fade)
                }
                self?.deleteArrays = nil
                self?.insertArrays = nil
                self?.reloadArrays = nil
            }
        }
    }
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        DispatchQueue.main.async { [weak self] in
            switch type {
            case .insert:
                self?.tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
                break
                
            case .delete:
                self?.tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
                break
                
            default:
                break
            }
        }
    }
}
#endif
