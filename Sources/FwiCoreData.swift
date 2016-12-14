//  Project name: FwiCore
//  File name   : FwiCoreData.swift
//
//  Author      : Dung Vu
//  Created date: 6/22/16
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

import Foundation
import CoreData


public protocol FwiCoreData {
}


public extension FwiCoreData where Self: NSManagedObject {
    
    /// Fetch all entities.
    ///
    /// - parameter context (required): a managed object context to search
    /// - parameter predicate (optional): to filter entity list
    /// - parameter sortDescriptor (optional): to sort entity list
    /// - parameter groupBy (optional): to group entity list into smaller list
    /// - parameter limit (optional): to limit the number of entities within the list
    public static func allEntities(fromContext context: NSManagedObjectContext?, predicate p: NSPredicate? = nil, sortDescriptor s: [NSSortDescriptor]? = nil, groupBy g: [AnyObject]? = nil, limit l: Int = 0) -> [Self]? {
        /* Condition validation */
        guard let c = context, let entityName = NSStringFromClass(self).split(".").last else {
            return nil
        }
        
        let request = NSFetchRequest<Self>(entityName: entityName)
        
        // Apply standard condition
        request.predicate = p
        request.sortDescriptors = s
        
        // Apply group by condition
        if let groupBy = g , groupBy.count > 0 {
            request.propertiesToFetch = groupBy
            request.returnsDistinctResults = true
            request.resultType = .dictionaryResultType
        }
        
        // Apply limit
        if l > 0 {
            request.fetchLimit = l
        }
        
        var entities: [Self]?
        c.performAndWait {[weak c] in
            guard let c = c else {
                return
            }
            // Perform fetch
            entities = try? c.fetch(request)
        }
        
        // Return result
        return entities
    }
    
    /// Fetch an entity base on search condition. Create new if necessary.
    ///
    /// - parameter context (required): a managed object context to search
    /// - parameter predicate (optional): to filter entity list
    /// - parameter shouldCreate (optional): create new entity if necessary
    public static func entity(fromContext context: NSManagedObjectContext?, predicate p: NSPredicate? = nil, shouldCreate create: Bool = false) -> Self? {
        /* Condition validation */
        guard let c = context else {
            return nil
        }
        
        // Find before create
        let entities = allEntities(fromContext: c, predicate: p, limit: 1)
        var entity = entities?.first
        
        if entity == nil && create {
            entity = newEntity(withContext: context)
        }
        return entity
    }
    
    /// Count all entities.
    ///
    /// - parameter context (required): a managed object context to count
    /// - parameter predicate (optional): to filter entity list
    public static func count(fromContext context: NSManagedObjectContext?, predicate p: NSPredicate? = nil) -> Int {
        /* Condition validation */
        guard let c = context, let entityName = NSStringFromClass(self).split(".").last else {
            return 0
        }
        
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.includesPropertyValues = false
        request.includesSubentities = false
        request.predicate = p
        
        var counter = 0
        c.performAndWait {[weak c] in
            guard let c = c else {
                return
            }
            
            
            do {
                counter = try c.count(for: request)
            }
            catch _ {
                counter = 0
            }
        }
        return counter
    }
    
    /// Insert new entity.
    ///
    /// - parameter context (required): a managed object context to insert
    public static func newEntity(withContext context: NSManagedObjectContext?) -> Self? {
        /* Condition validation */
        guard let c = context, let entityName = NSStringFromClass(self).split(".").last else {
            return nil
        }
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: c) as? Self
    }
    
    /// Delete all entities.
    ///
    /// - parameter context (required): a managed object context to delete
    /// - parameter predicate (optional): to filter entities when deleting
    public static func deleteAllEntities(fromContext context: NSManagedObjectContext?, predicate p: NSPredicate? = nil) {
        let entities = allEntities(fromContext: context, predicate: p)
        // Using mark and delete , it'll fast and safe
        entities?.forEach({
            context?.delete($0)
        })
        try? context?.save()
    }
}
