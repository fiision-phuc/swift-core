//  Project name: FwiCore
//  File name   : ZinioCoreDataProtocol.swift
//
//  Author      : Dung Vu
//  Created date: 6/22/16
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


/** Protocol For NSManagedObject with process data  */
@objc
public protocol ZinioCoreDataProtocol {
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
