// Project name: ZinioReader
//  File name   : FwiPersistentManager.swift
//
//  Author      : Dung Vu
//  Created date: 6/8/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Zinio Pro. All rights reserved.
//  --------------------------------------------------------------

import Foundation
import CoreData

public class FwiPersistentManager: NSObject {

    // MARK: Class's constructors
    private override init() {
        super.init()
    }

    // MARK: Class's properties
    public private (set) lazy var managedModel: NSManagedObjectModel = {
        guard let modelURL: NSURL = self.bundle.URLForResource(self.dataModel, withExtension: "momd") else {
            fatalError("Not Found Model!!!")
        }
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    public private (set) lazy var persistentCoordinator: NSPersistentStoreCoordinator? = {
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedModel)

        let storeDB1 = "\(self.dataModel).sqlite"
        let storeDB2 = "\(self.dataModel).sqlite-shm"
        let storeDB3 = "\(self.dataModel).sqlite-wal"

        guard let storeURL1: NSURL = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB1) else {
            fatalError("Not Found Cache directory!!!")
        }

        let storeURL2: NSURL? = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB2)
        let storeURL3: NSURL? = NSURL.cacheDirectory()?.URLByAppendingPathComponent(storeDB3)

        // try delete if database in cache exist
        let fileManager = NSFileManager.defaultManager()

        fileManager.deleteFileAtPath(storeURL1)
        fileManager.deleteFileAtPath(storeURL2)
        fileManager.deleteFileAtPath(storeURL3)

        let options = [NSSQLitePragmasOption: ["journal_mode": "WAL"],
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL1, options: options)

            try storeURL1.setResourceValues([NSURLIsExcludedFromBackupKey: true])
            try storeURL2?.setResourceValues([NSURLIsExcludedFromBackupKey: true])
            try storeURL3?.setResourceValues([NSURLIsExcludedFromBackupKey: true])

        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return coordinator
    }()

    public private (set) lazy var managedContext: NSManagedObjectContext = {
        let coordinator = self.persistentCoordinator
        var managedObjectContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return managedObjectContext
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

    private var dataModel: String!
    private var bundle: NSBundle!

    // MARK: Class's public methods

    /** Save current working context. */
    public func saveContext() -> NSError? {
        if managedContext.hasChanges {
            var errorResult: NSError?
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
