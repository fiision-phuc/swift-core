//  Project name: FwiCore
//  File name   : FwiPersistentManagerTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/21/16
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
