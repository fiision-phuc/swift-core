//  Project name: FwiCore
//  File name   : FwiEntityTableViewModel.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/4/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2012, 2016 Fiision Studio.
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

import UIKit
import CoreData
import Foundation


public final class FwiEntityTableViewModel<T: NSManagedObject> : FwiEntityViewModel<T> {

    /// MARK: Class's constructors
    public convenience init(_ tableView: UITableView?, context c: NSManagedObjectContext?) {
        self.init(c)
        self.tableView = tableView
    }
    
    /// MARK: Class's properties
    fileprivate weak var tableView: UITableView?
    
    /// MARK: Class's private methods
    internal override func performFetch() {
        super.performFetch()
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    /// MARK: NSFetchedResultsControllerDelegate's members
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { [weak self] in
            if let array = self?.deleteArrays {
                self?.tableView?.deleteRows(at: array, with: .fade)
            }
            if let array = self?.insertArrays {
                self?.tableView?.insertRows(at: array, with: .fade)
            }
            if let array = self?.reloadArrays {
                self?.tableView?.reloadRows(at: array, with:.fade)
            }
            self?.deleteArrays = nil
            self?.insertArrays = nil
            self?.reloadArrays = nil
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
