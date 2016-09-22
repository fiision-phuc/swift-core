//  Project name: FwiCore
//  File name   : FwiPersistentManagerTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/21/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import XCTest
import CoreData
@testable import FwiCore


class FwiPersistentManagerTest: XCTestCase {
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tear Down
    override func tearDown() {
        let (storeDB1, storeDB2, storeDB3) = ("Sample.sqlite", "Sample.sqlite-shm", "Sample.sqlite-wal")
        let storeURL1 = URL.cacheDirectory() + storeDB1
        let storeURL2 = URL.cacheDirectory() + storeDB2
        let storeURL3 = URL.cacheDirectory() + storeDB3
        let fileManager = FileManager.default
        
        fileManager.removeFile(atURL: storeURL1)
        fileManager.removeFile(atURL: storeURL2)
        fileManager.removeFile(atURL: storeURL3)
        
        super.tearDown()
    }
    
    // MARK: Test Cases
    func testInitBinaryStore() {
        let persistent = FwiPersistentManager(withModel: "Sample", fromBundle: Bundle(for: FwiPersistentManagerTest.self), storeType: .binary)
        
        XCTAssertNotNil(persistent, "Expected not nil but found '\(persistent)'.")
        XCTAssertNotNil(persistent.managedContext, "Expected not nil but found '\(persistent.managedContext)'.")
        XCTAssertNotNil(persistent.managedModel, "Expected not nil but found '\(persistent.managedModel)'.")
        XCTAssertNotNil(persistent.persistentCoordinator, "Expected not nil but found '\(persistent.persistentCoordinator)'.")
        
        testContext(persistent.managedContext)
    }
    
    func testInitMemoryStore() {
        let persistent = FwiPersistentManager(withModel: "Sample", fromBundle: Bundle(for: FwiPersistentManagerTest.self), storeType: .memory)

        XCTAssertNotNil(persistent, "Expected not nil but found '\(persistent)'.")
        XCTAssertNotNil(persistent.managedContext, "Expected not nil but found '\(persistent.managedContext)'.")
        XCTAssertNotNil(persistent.managedModel, "Expected not nil but found '\(persistent.managedModel)'.")
        XCTAssertNotNil(persistent.persistentCoordinator, "Expected not nil but found '\(persistent.persistentCoordinator)'.")
        
        testContext(persistent.managedContext)
    }
    
    func testInitSQLiteStore() {
        let persistent = FwiPersistentManager(withModel: "Sample", fromBundle: Bundle(for: FwiPersistentManagerTest.self), storeType: .sqlite)
        
        XCTAssertNotNil(persistent, "Expected not nil but found '\(persistent)'.")
        XCTAssertNotNil(persistent.managedContext, "Expected not nil but found '\(persistent.managedContext)'.")
        XCTAssertNotNil(persistent.managedModel, "Expected not nil but found '\(persistent.managedModel)'.")
        XCTAssertNotNil(persistent.persistentCoordinator, "Expected not nil but found '\(persistent.persistentCoordinator)'.")
        
        testContext(persistent.managedContext)
    }
    
    fileprivate func testContext(_ context: NSManagedObjectContext) {
        let person = Person.newEntity(withContext: context)
        person?.firstName = "Test"
        person?.lastName = "Test"
        
        XCTAssertNotNil(person?.objectID, "Expected not nil but found '\(person?.objectID)'.")
        do {
            try context.save()
        }
        catch _ {
            XCTFail("Could not save new object into context.")
        }
        
        let persons = Person.allEntities(fromContext: context)
        XCTAssertEqual(persons?.count, 1, "Expected '1' but found: '\(persons?.count)'.")
    }
}
