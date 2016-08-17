// Project name: ZinioReader
//  File name   : ZinioCoreDataProtocol.swift
//
//  Author      : Dung Vu
//  Created date: 6/22/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Zinio Pro. All rights reserved.
//  --------------------------------------------------------------

import Foundation
import CoreData

/** Protocol For NSManagedObject with process data  */
@objc public protocol ZinioCoreDataProtocol {
}

public extension ZinioCoreDataProtocol where Self: NSManagedObject {

    /** Fetch objects base on search condition for specific Entity type and sort them,
     * @param groupBy : returned result can be grouped by some properties (id,name,....)
     * @param limit : number of objects will be returned, 0 = unlimited
     */
    static func fetchAllEntitiesFromContext(context: NSManagedObjectContext?, predicate: NSPredicate? = nil, sorts: [NSSortDescriptor]? = nil, groupBy: [AnyObject]? = nil, limit: Int = 0) -> [Self]? {
        /* Condition validation */
        guard let context = context else {
            return nil
        }

        var entities = [Self]()

        context.performBlockAndWait {
            let request = NSFetchRequest(entityName: NSStringFromClass(self))

            // apply sorting
            request.sortDescriptors = sorts

            // apply filter
            request.predicate = predicate

            if let groupBy = groupBy where groupBy.count > 0 {
                request.propertiesToFetch = groupBy
                request.returnsDistinctResults = true
                request.resultType = .DictionaryResultType
            }

            if limit > 0 {
                request.fetchLimit = limit
            }
            do {
                let result = try context.executeFetchRequest(request)
                result.forEach({ (obj) in
                    if let item = obj as? Self {
                        entities.append(item)
                    }
                })

            } catch {
                print("Fetch Error")
            }
        }

        if entities.count > 0 {
            return entities
        }

        return nil
    }

    /** Return an object for specific Entity type with search condition
     * @param shouldCreate : Will create new object when find no one in database or not
     */
    static func fetchEntityWithPredicate(context: NSManagedObjectContext?, predicate: NSPredicate? = nil, shouldCreate: Bool = false) -> Self? {
        /* Condition validation */
        guard let context = context else { return nil }
        var entities: [NSManagedObject]?

        context.performBlockAndWait {
            let request = NSFetchRequest(entityName: NSStringFromClass(self))

            // apply filter
            request.predicate = predicate

            do {
                entities = try context.executeFetchRequest(request) as? [NSManagedObject]
            } catch {
                print("Fetch Error")
            }

        }

        var entity = entities?.first as? Self
        if entity == nil && shouldCreate {
            entity = self.newEntityWithContext(context)
        }

        return entity
    }

    /** Insert new object in CoreData */
    static func newEntityWithContext(context: NSManagedObjectContext?) -> Self? {
        guard let context = context else { return nil }
        return NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(self), inManagedObjectContext: context) as? Self
    }

    /** Delete all objects of specific Entity type from Core Data*/
    static func deleteAllEntitiesWithContext(context: NSManagedObjectContext?, predicate: NSPredicate? = nil) {
        let entities = self.fetchAllEntitiesFromContext(context, predicate: predicate)
        entities?.forEach({
            $0.deleteFromDatabase()
        })
    }

}

public extension NSManagedObject {
    /** Delete self from Core Data */
    func deleteFromDatabase() {
        self.managedObjectContext?.performBlockAndWait({ [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.managedObjectContext?.deleteObject(weakSelf)
        })
    }
}
