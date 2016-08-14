// Project name: FwiCore
//  File name   : FwiOperation.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/23/14
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

import UIKit
import Foundation


public class FwiOperation: NSOperation {

    // MARK: Class's constructors
    public override init() {
        super.init()
    }

    // MARK: Class's properties
    public var isLongOperation = false
    public lazy var identifier: String = {
        return String()
    }()

    private var isFinished  = false
    private var isCancelled = false
    private var isExecuting = false
    private var userInfo: [String: AnyObject]?
    private var bgTask: UIBackgroundTaskIdentifier?

    // MARK: Class's public methods
    public func execute() {
        // Always check for cancellation before launching the task.
        if cancelled {
            operationCompleted()
        }
        else {
            // Register bgTask
            bgTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
                /* Condition validatioN: Is long operation */
                if self.isLongOperation {
                    return
                }

                // Cancel this operation
                self.cancel()
                self.operationCompleted()
            })

            // Add to operation queue
            operationQueue.addOperation(self)
        }
    }

    /** Implement business logic. */
    public func businessLogic() {
        preconditionFailure("This function must be overridden.")
    }

    // MARK: Class's private methods
    private func operationCompleted() {
        // Terminate operation
        willChangeValueForKey("isExecuting")
        willChangeValueForKey("isFinished")
        isExecuting = false
        isFinished = true
        didChangeValueForKey("isExecuting")
        didChangeValueForKey("isFinished")

        // Terminate background task
        if let task = bgTask where bgTask != UIBackgroundTaskInvalid {
            UIApplication.sharedApplication().endBackgroundTask(task)
            bgTask = UIBackgroundTaskInvalid
        }
    }

    // MARK: NSOperation's members
    public override var asynchronous: Bool {
        get {
            return true
        }
    }
    public override var executing: Bool {
        get {
            return isExecuting
        }
    }
    public override var finished: Bool {
        get {
            return isFinished
        }
    }
    public override var ready: Bool {
        get {
            return true
        }
    }

    public override func cancel() {
        isCancelled = true
        super.cancel()
    }

    public override func start() {
        autoreleasepool { () -> () in
            // Always check for cancellation before launching the task.
            if cancelled {
                operationCompleted()
            }
            else {
                // If the operation is not canceled, begin executing the task.
                willChangeValueForKey("isExecuting")
                isExecuting = true
                didChangeValueForKey("isExecuting")

                // Process business
                businessLogic()

                // Terminate background task
                operationCompleted()
            }
        }
    }
}


// MARK: Extension
public extension FwiOperation {

    /** Execute business with completion closure. */
    public func executeWithCompletion(completion:(() -> Void)?) {
        super.completionBlock = completion
        execute()
    }
}


// MARK: Private queue
public var operationQueue: NSOperationQueue = {
    let operationQueue = NSOperationQueue()
    operationQueue.maxConcurrentOperationCount = 5
    operationQueue.qualityOfService = NSQualityOfService.Utility
    
    return operationQueue
}()