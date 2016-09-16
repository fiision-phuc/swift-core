//  Project name: FwiCore
//  File name   : FwiPersistentManager.swift
//
//  Author      : Dung Vu
//  Created date: 6/8/16
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

import Foundation
import CoreData


public final class FwiPersistentManager {

    // MARK: Class's constructors
    public init(dataModel: String, modelBundle bundle: Bundle = Bundle.main) {
        self.bundle = bundle
        self.dataModel = dataModel

        // Register core data changed notification
        NotificationCenter.default.addObserver(self, selector: #selector(FwiPersistentManager.handleContextDidSaveNotification(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    // MARK: Cleanup memory
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Class's properties
    public fileprivate (set) lazy var managedModel: NSManagedObjectModel = {
        if let modelURL = self.bundle.url(forResource: self.dataModel, withExtension: "momd"),
           let managedModel = NSManagedObjectModel(contentsOf: modelURL)
        {
            return managedModel
        }
        fatalError("\(self.dataModel) model is not available!")
    }()
    public fileprivate (set) lazy var managedContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return managedObjectContext
    }()
    public fileprivate (set) lazy var persistentCoordinator: NSPersistentStoreCoordinator = {
        let (storeDB1, storeDB2, storeDB3) = ("\(self.dataModel).sqlite", "\(self.dataModel).sqlite-shm", "\(self.dataModel).sqlite-wal")
        guard let storeURL1 = URL.cacheDirectory() + storeDB1,
              let storeURL2 = URL.cacheDirectory() + storeDB2,
              let storeURL3 = URL.cacheDirectory() + storeDB3
        else {
            fatalError("Cache directory could not be found!")
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedModel)
        let options = [NSSQLitePragmasOption:["journal_mode":"WAL"],
                       NSInferMappingModelAutomaticallyOption:true,
                       NSMigratePersistentStoresAutomaticallyOption:true] as [String : Any]

        for i in 0 ... 1 {
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL1, options: options)
                // try (storeURL1 as URL).setResourceValues([URLResourceKey.isExcludedFromBackupKey: true as AnyObject])
                // try (storeURL2 as URL).setResourceValues([URLResourceKey.isExcludedFromBackupKey: true as AnyObject])
                // try (storeURL3 as URL).setResourceValues([URLResourceKey.isExcludedFromBackupKey: true as AnyObject])
                break

            }
            catch _ {
                // Note: If the first time fail, we remove everything but not second time.
                if i == 0 {
                    let fileManager = FileManager.default
                    fileManager.removeFile(atURL: storeURL1)
                    fileManager.removeFile(atURL: storeURL2)
                    fileManager.removeFile(atURL: storeURL3)
                }
                else {
                    fatalError("Could not create persistent store coordinator for \(self.dataModel) model!")
                }
            }
        }
        return coordinator
    }()

    fileprivate var bundle: Bundle
    fileprivate var dataModel: String


    // MARK: Class's public methods
    @discardableResult
    public func saveContext() -> NSError? {
        var error: NSError?
        managedContext.performAndWait({ [weak self] in
            do {
                try self?.managedContext.save()
            } catch let err as NSError {
                error = err
            }
            })
        return error
    }

    /** Return a sub managed object context that had been optimized to serve the update data process. */
    public func importContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        managedObjectContext.undoManager = nil

        return managedObjectContext
    }


    // MARK: Class's private methods
    @objc
    fileprivate func handleContextDidSaveNotification(_ notification: Notification) {
        guard let otherContext = notification.object as? NSManagedObjectContext , otherContext !== self.managedContext else {
            return
        }
        managedContext.mergeChanges(fromContextDidSave: notification)
    }
}
