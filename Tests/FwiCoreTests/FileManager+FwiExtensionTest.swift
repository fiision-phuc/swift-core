//  Project name: FwiCore
//  File name   : FileManager+FwiExtensionTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/27/16
//  --------------------------------------------------------------
//  Copyright © 2012, 2019 Fiision Studio. All Rights Reserved.
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
@testable import FwiCore


class FileManagerFwiExtensionTest: XCTestCase {
    
    
    fileprivate var directoryURL1: URL?
    fileprivate var directoryURL2: URL?
    fileprivate var fileURL: URL?
    
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
        
        directoryURL1 = URL.cacheDirectory()?.appendingPathComponent("sample/testDirectory1")
        directoryURL2 = URL.cacheDirectory()?.appendingPathComponent("sample/testDirectory2")
        fileURL = URL.cacheDirectory()?.appendingPathComponent("sample/file")
        
        try? FileManager.default.createDirectory(URL.cacheDirectory()?.appendingPathComponent("sample"))
        if let url = fileURL {
            do {
                try "FwiCore".toData()?.write(to: url)
            } catch let err as NSError {
                Log.debug("Could not create file '\(err.localizedDescription)'.")
            }
        }
    }
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
        
        if let url = URL.cacheDirectory()?.appendingPathComponent("sample") {
            do {
                try FileManager.default.removeItem(at: url)
            } catch _ {}
        }
    }
    
    
    // MARK: Test Cases
    func testCreateDirectory() {
        do {
            try FileManager.default.createDirectory(nil)
        } catch {
            XCTAssertNotNil(error, "FileManager should not allow to create nil directory '\(String(describing: error))'.")
        }

        do {
            try FileManager.default.createDirectory(URL.cacheDirectory())
        } catch {
            XCTAssertNotNil(error, "FileManager should not allow to create root cache directory '\(String(describing: error))'.")
        }

        do {
            try FileManager.default.createDirectory(directoryURL1)
        } catch {
            XCTAssertNil(error, "FileManager should be able to create directory for a given path but found '\(String(describing: error))'.")
        }
    }
    
    func testDirectoryExists() {
        XCTAssertFalse(FileManager.default.directoryExists(directoryURL1), "FileManager should return false when directory is not available.")
        XCTAssertFalse(FileManager.default.directoryExists(fileURL), "FileManager should return false when given a file URL.")
        
        try? FileManager.default.createDirectory(directoryURL1)
        XCTAssertTrue(FileManager.default.directoryExists(directoryURL1), "FileManager should return true when directory is available.")
    }
    
    func testMoveDirectory() {
        try? FileManager.default.createDirectory(directoryURL1)
        XCTAssertTrue(FileManager.default.directoryExists(directoryURL1), "FileManager should return true when directory is available.")
        XCTAssertFalse(FileManager.default.directoryExists(directoryURL2), "FileManager should return false when directory is not available.")

        do {
            try FileManager.default.moveDirectory(directoryURL1, to: directoryURL2)
        } catch {
            XCTAssertNil(error, "FileManager should be able to move directory but found '\(String(describing: error))'.")
        }

        XCTAssertFalse(FileManager.default.directoryExists(directoryURL1), "FileManager should return false when directory is not available.")
        XCTAssertTrue(FileManager.default.directoryExists(directoryURL2), "FileManager should return true when directory is available.")
    }
    
    func testRemoveDirectory() {
        try? FileManager.default.createDirectory(directoryURL1)
        do {
            try FileManager.default.removeDirectory(directoryURL1)
        } catch {
            XCTAssertNil(error, "FileManager should be able to remove directory but found '\(String(describing: error))'.")
        }
        XCTAssertFalse(FileManager.default.directoryExists(directoryURL1), "FileManager should return false when directory is not available.")
    }
    
    func testFileExists() {
        XCTAssertTrue(FileManager.default.fileExists(fileURL), "FileManager should return true when file is available.")
    }
}
