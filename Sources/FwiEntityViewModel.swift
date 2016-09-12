//  Project name: FwiCore
//  File name   : FwiEntityViewModel.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/5/16
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
import Foundation
import CoreData


open class FwiEntityViewModel<T: NSFetchRequestResult> : NSObject, NSFetchedResultsControllerDelegate {

    /// MARK: Class's constructors
    public convenience init(_ context: NSManagedObjectContext?) {
        self.init()
        self.context = context
    }
    
    /// MARK: Class's properties
    open lazy private (set) var fetchedController: NSFetchedResultsController<T>? = {
        guard let c = self.context, let entityName = NSStringFromClass(T.self).split(".").last else {
            return nil
        }
        let request = NSFetchRequest<T>(entityName: entityName)
        request.sortDescriptors = self.sortDescriptors ?? []
        request.predicate = self.predicate
        request.fetchBatchSize = 20
        
        // Create Fetch results controller
        let controller = NSFetchedResultsController<T>(fetchRequest: request, managedObjectContext: c, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    open var sortDescriptors: [NSSortDescriptor]? {
        didSet {
            performFetch()
        }
    }
    
    open var predicate: NSPredicate? {
        didSet {
            performFetch()
        }
    }
    
    fileprivate var context: NSManagedObjectContext?
    internal var deleteArrays: [IndexPath]?
    internal var insertArrays: [IndexPath]?
    internal var reloadArrays: [IndexPath]?
    
    /// MARK: Class's public methods
    /// Return number of sections.
    open func sectionCount() -> Int {
        guard let sections = fetchedController?.sections, sections.count > 0 else {
            return 0
        }
        return sections.count
    }
    
    /// Return number of items for each section.
    open func itemCount(forSection section: Int) -> Int {
        guard let sections = fetchedController?.sections, sections.count > 0 else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    /// Return item for index path.
    open func item(forIndexPath indexPath: IndexPath) -> T? {
        return fetchedController?.object(at: indexPath)
    }

    /// MARK: Class's private methods
    internal func performFetch() {
        fetchedController?.fetchRequest.sortDescriptors = sortDescriptors
        fetchedController?.fetchRequest.predicate = predicate
        
        // Perform fetched
        do {
            try fetchedController?.performFetch()
        } catch _ { /* The error is being ignored. */ }
    }
    
    /// MARK: NSFetchedResultsControllerDelegate's members
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        deleteArrays = [IndexPath]()
        insertArrays = [IndexPath]()
        reloadArrays = [IndexPath]()
    }
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            if let index = newIndexPath {
                insertArrays?.append(index)
            }
            break
            
        case .delete:
            if let index = indexPath {
                deleteArrays?.append(index)
            }
            break
            
        case .move:
            if let index = newIndexPath {
                insertArrays?.append(index)
            }
            if let index = indexPath {
                deleteArrays?.append(index)
            }
            break
            
        case .update:
            if let index = indexPath {
                reloadArrays?.append(index)
            }
            break;
        }
    }
}
