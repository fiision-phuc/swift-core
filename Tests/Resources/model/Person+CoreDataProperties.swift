//
//  Person+CoreDataProperties.swift
//  FwiCore
//
//  Created by Phuc, Tran Huu on 9/21/16.
//  Copyright © 2016 Fiision Studio. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}
