//  Project name: FwiCore
//  File name   : FwiPersistentManager.swift
//
//  Author      : Dung Vu
//  Created date: 6/8/16
//  Version     : 2.0.0
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

import Foundation
import CoreData


/// Define persistent store's type.
public enum FwiPersistentType {
    case binary
    case memory
    case sqlite

    var store: String {
        switch self {

        case .binary:
            return NSBinaryStoreType

        case .memory:
            return NSInMemoryStoreType

        case .sqlite:
            return NSSQLiteStoreType
        }
    }
}


public final class FwiPersistentManager {

    // MARK: Class's constructors
    /// Create persistent manager.
    ///
    /// - parameter model (required): name of model schema without momd extension
    /// - parameter bundle (optional): the bundle contains the model schema. Default is main bundle
    /// - parameter storeType (optional): the persistent's type. Default is SQLite
    /// - parameter rootLocation (optional): the location to stored database. Default is cache folder
    public init(withModel m: String, fromBundle b: Bundle = Bundle.main, storeType t: FwiPersistentType = .sqlite, rootLocation l: URL? = URL.cacheDirectory()) {
        bundle = b
        dataModel = m
        storeType = t
        rootLocation = l

        // Register core data changed notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FwiPersistentManager.handleContextDidSaveNotification(_:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }

    // MARK: Cleanup memory
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Class's properties
    /// Return managed object model instance.
    public fileprivate(set) lazy var managedModel: NSManagedObjectModel = {
        guard let modelURL = self.bundle.url(forResource: self.dataModel, withExtension: "momd"), let managedModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("\(self.dataModel) model is not available!")
        }
        return managedModel
    }()

    /// Return main managed object context.
    public fileprivate(set) lazy var managedContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return managedObjectContext
    }()

    /// Return persistent store coordinator.
    public fileprivate(set) lazy var persistentCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedModel)
        
        if self.storeType == .memory {
            do {
                try coordinator.addPersistentStore(ofType: self.storeType.store, configurationName: nil, at: nil, options: nil)
            }
            catch _ {
                fatalError("Could not create persistent store coordinator for \(self.dataModel) model!")
            }
        }
        else {
            let storeDB1 = "\(self.dataModel).sqlite"
            let storeDB2 = "\(self.dataModel).sqlite-shm"
            let storeDB3 = "\(self.dataModel).sqlite-wal"
            let options: [String : Any] = [NSSQLitePragmasOption:["journal_mode":"WAL"],
                                           NSInferMappingModelAutomaticallyOption:true,
                                           NSMigratePersistentStoresAutomaticallyOption:true]
            
            guard let storeURL1 = self.rootLocation + storeDB1, let storeURL2 = self.rootLocation + storeDB2, let storeURL3 = self.rootLocation + storeDB3 else {
                fatalError("Cache directory could not be found!")
            }
            
            // Try to map schema
            for i in 0 ... 1 {
                do {
                    try coordinator.addPersistentStore(ofType: self.storeType.store, configurationName: nil, at: storeURL1, options: options)
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
        }
        return coordinator
    }()

    fileprivate var bundle: Bundle
    fileprivate var dataModel: String
    fileprivate var rootLocation: URL?
    fileprivate var storeType: FwiPersistentType
    fileprivate let _lock = NSRecursiveLock()

    // MARK: Class's public methods
    @discardableResult
    public func saveContext() -> NSError? {
        guard managedContext.hasChanges else {
            return nil
        }
        _lock.lock(); defer { _lock.unlock() }
        
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

    /// Return a sub managed object context that had been optimized to serve the update data process.
    public func importContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = persistentCoordinator
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }

    // MARK: Class's private methods
    @objc
    fileprivate func handleContextDidSaveNotification(_ notification: Notification) {
        _lock.lock(); defer { _lock.unlock() }
        guard let otherContext = notification.object as? NSManagedObjectContext , otherContext !== self.managedContext else {
            return
        }
        managedContext.mergeChanges(fromContextDidSave: notification)
    }
}
