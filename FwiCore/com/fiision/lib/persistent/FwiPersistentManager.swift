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
    }

    // MARK: Class's properties
    public private (set) lazy var managedModel: NSManagedObjectModel = {
        if let modelURL = self.bundle.URLForResource(self.dataModel, withExtension: "momd"), managedModel = NSManagedObjectModel(contentsOfURL: modelURL) {
            return managedModel
        }
        fatalError("Data model is not available!")
    }()
    public private (set) lazy var managedContext: NSManagedObjectContext = {
        let coordinator = self.persistentCoordinator
        var managedObjectContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return managedObjectContext
    }()
    public private (set) lazy var persistentCoordinator: NSPersistentStoreCoordinator? = {
        let storeDB1 = "\(self.dataModel).sqlite"
        let storeDB2 = "\(self.dataModel).sqlite-shm"
        let storeDB3 = "\(self.dataModel).sqlite-wal"
        guard let storeURL1 = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB1) else {
            fatalError("Cache directory could not be found!")
        }
        guard let storeURL2 = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB2) else {
            fatalError("Cache directory could not be found!")
        }
        guard let storeURL3 = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB3) else {
            fatalError("Cache directory could not be found!")
        }

        let options = [NSSQLitePragmasOption:["journal_mode":"WAL"],
                       NSInferMappingModelAutomaticallyOption:true,
                       NSMigratePersistentStoresAutomaticallyOption:true]
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedModel)
        
        do {
            let persistentStore = try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL1, options: options)
            
            try storeURL1.setResourceValues([NSURLIsExcludedFromBackupKey: true])
            try storeURL2.setResourceValues([NSURLIsExcludedFromBackupKey: true])
            try storeURL3.setResourceValues([NSURLIsExcludedFromBackupKey: true])

        } catch let error as NSError {
            // try delete if database in cache exist
//            let fileManager = NSFileManager.defaultManager()
//            fileManager.deleteFileAtPath(storeURL1)
//            fileManager.deleteFileAtPath(storeURL2)
//            fileManager.deleteFileAtPath(storeURL3)
        }

        return coordinator
    }()

    

    /** Return a sub managed object context that had been optimized to serve the update data process. */
    public private (set) lazy var importContext: NSManagedObjectContext = {
        let coordinator = self.persistentCoordinator
        var managedObjectContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }()

    private var bundle: NSBundle
    private var dataModel: String
    

    // MARK: Class's public methods

    /** Save current working context. */
    public func saveContext() -> NSError? {
        if managedContext.hasChanges {
            var errorResult: NSError?
            managedContext.performBlockAndWait({
                
            })
            
            managedContext.performBlockAndWait({ [weak self] in
                do {
                    try self?.managedContext.save()
                } catch let error as NSError {
                    errorResult = error
                }
            })
            return errorResult
        } else {
            return nil
        }
    }

    /** Handle did save event from other context beside main context. */
    func _handleContextDidSaveNotification(notification: NSNotification) {
        guard let otherContext = notification.object as? NSManagedObjectContext where otherContext != self.managedContext else {
            return
        }

        managedContext.mergeChangesFromContextDidSaveNotification(notification)
    }

    // MARK: Class's private methods
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// Creation
extension FwiPersistentManager {

    // MARK: Class's static constructors
    /** Create persistent manager for specific data model. */
    public class func persistentWithDataModel(dataModel: String, bundle: NSBundle) -> FwiPersistentManager? {
        if dataModel.length() == 0 { return nil }
        return FwiPersistentManager(dataModel: dataModel, bundle: bundle)
    }

    // MARK: Class's constructors
    private convenience init(dataModel: String, bundle: NSBundle) {
        self.init()

        self.dataModel = dataModel
        self.bundle = bundle

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FwiPersistentManager._handleContextDidSaveNotification(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)

    }
}
