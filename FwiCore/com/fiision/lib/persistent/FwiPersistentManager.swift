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


public class FwiPersistentManager {

    // MARK: Class's constructors
    public init(dataModel: String, modelBundle bundle: NSBundle = NSBundle.mainBundle()) {
        self.bundle = bundle
        self.dataModel = dataModel

        // Register core data changed notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FwiPersistentManager.handleContextDidSaveNotification(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }


    // MARK: Cleanup memory
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    // MARK: Class's properties
    public private (set) lazy var managedModel: NSManagedObjectModel = {
        if let modelURL = self.bundle.URLForResource(self.dataModel, withExtension: "momd"), managedModel = NSManagedObjectModel(contentsOfURL: modelURL) {
            return managedModel
        }
        fatalError("\(self.dataModel) model is not available!")
    }()
    public private (set) lazy var managedContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        return managedObjectContext
    }()
    public private (set) lazy var persistentCoordinator: NSPersistentStoreCoordinator = {
        let (storeDB1, storeDB2, storeDB3) = ("\(self.dataModel).sqlite", "\(self.dataModel).sqlite-shm", "\(self.dataModel).sqlite-wal")
        guard let
            storeURL1 = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB1),
            storeURL2 = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB2),
            storeURL3 = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB3) else {
            fatalError("Cache directory could not be found!")
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedModel)
        let options = [NSSQLitePragmasOption:["journal_mode":"WAL"],
                       NSInferMappingModelAutomaticallyOption:true,
                       NSMigratePersistentStoresAutomaticallyOption:true]

        for i in 0 ..< 2 {
            do {
                try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL1, options: options)
                try storeURL1.setResourceValues([NSURLIsExcludedFromBackupKey: true])
                try storeURL2.setResourceValues([NSURLIsExcludedFromBackupKey: true])
                try storeURL3.setResourceValues([NSURLIsExcludedFromBackupKey: true])
                break

            } catch _ {
                // Note: If the first time fail, we remove everything but not second time.
                if i == 0 {
                    let fileManager = NSFileManager.defaultManager()
                    fileManager.deleteFileAtURL(storeURL1)
                    fileManager.deleteFileAtURL(storeURL2)
                    fileManager.deleteFileAtURL(storeURL3)
                } else {
                    fatalError("Could not create persistent store coordinator for \(self.dataModel) model!")
                }
            }
        }
        return coordinator
    }()

    private var bundle: NSBundle
    private var dataModel: String


    // MARK: Class's public methods
    public func saveContext() -> NSError? {
        var error: NSError?
        managedContext.performBlockAndWait({ [weak self] in
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
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        managedObjectContext.undoManager = nil

        return managedObjectContext
    }


    // MARK: Class's private methods
    @objc
    private func handleContextDidSaveNotification(notification: NSNotification) {
        guard let otherContext = notification.object as? NSManagedObjectContext where otherContext !== self.managedContext else {
            return
        }
        managedContext.mergeChangesFromContextDidSaveNotification(notification)
    }
}
