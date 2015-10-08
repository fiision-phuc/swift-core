//  Project name: FwiCore
//  File name   : FwiOperation.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/23/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
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
//  testing. Monster Group  disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import Foundation
import UIKit


public enum FwiOperationState : UInt8 {
    case Initialize = 0x00
    case Executing	= 0x01
    case Cancelled  = 0x02
    case Finished	= 0x03
    case Error      = 0x04
}


var operationQueue: NSOperationQueue?


public class FwiOperation : NSOperation {

    
    // MARK: Environment initialize
    public class override func initialize() {
        objc_sync_enter(self)  // Lock
        if (operationQueue == nil) {
            operationQueue = NSOperationQueue()
        }
        operationQueue?.maxConcurrentOperationCount = 5
        
        // Define quality of service if system version is from 8
        if let version = UIDevice.currentDevice().systemName.toInt() {
            if version >= 8 {
                operationQueue?.qualityOfService = NSQualityOfService.Utility
            }
        }
        objc_sync_exit(self)   // Unlock
    }
    public class func getPrivateQueue() -> NSOperationQueue? {
        return operationQueue
    }
    
    
    // MARK: Class's constructors
    public override init() {
        super.init()
    }
    
    
    // MARK: Class's properties
    public var identifier: String?
    public weak var delegate: FwiOperationDelegate?
    
    public var isLongOperation = false
    public var state = FwiOperationState.Initialize
    
    private var isFinished  = false
    private var isCancelled = false
    private var isExecuting = false
    
    private var userInfo: [String : AnyObject]?
    private var bgTask: UIBackgroundTaskIdentifier?
    
    
    // MARK: Class's public methods
    public func execute() {
        // Always check for cancellation before launching the task.
        if (self.cancelled) {
            self.operationCompleted()
        } else {
            // Register bgTask
            bgTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
                /* Condition validatioN: Is long operation */
                if (self.isLongOperation) {
                    return
                }
                
                // Cancel this operation
                self.cancel()
                
                // Terminate background task
                if (self.bgTask != nil && self.bgTask != UIBackgroundTaskInvalid) {
                    UIApplication.sharedApplication().endBackgroundTask(self.bgTask!)
                    self.bgTask = UIBackgroundTaskInvalid
                }
            })
            
            // Add to operation queue
            operationQueue?.addOperation(self)
        }
    }
    
    /** Implement business logic. */
    public func businessLogic() {
        // To be overrided.
    }
    
    
    // MARK: Class's private methods
    private func operationCompleted() {
        // Check operation stage
        if (state == .Executing) {
            state = .Finished
        }
        
        // Notify delegate
        delegate?.operationDidFinish?(self, withState: state.rawValue, userInfo: userInfo)
        
        // Terminate operation
        self.willChangeValueForKey("isExecuting")
        self.willChangeValueForKey("isFinished")
        isExecuting = false
        isFinished  = true
        self.didChangeValueForKey("isExecuting")
        self.didChangeValueForKey("isFinished")
        
        // Terminate background task
        if (bgTask != nil && bgTask != UIBackgroundTaskInvalid) {
            UIApplication.sharedApplication().endBackgroundTask(self.bgTask!)
            self.bgTask = UIBackgroundTaskInvalid
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
        state = .Cancelled
        
        // Notify delegate
        delegate?.operationDidCancel?(self)
        
        // Return event to super
        super.cancel()
    }
    
    public override func start() {
        autoreleasepool { () -> () in
            // Always check for cancellation before launching the task.
            if (self.cancelled) {
                self.operationCompleted()
            } else {
                self.delegate?.operationWillStart?(self)
                self.state = .Executing
                
                // If the operation is not canceled, begin executing the task.
                self.willChangeValueForKey("isExecuting")
                self.isExecuting = true
                self.didChangeValueForKey("isExecuting")
                
                // Process business
                self.businessLogic()
                
                // Terminate background task
                self.operationCompleted()
            }
        }
    }
}


// Extension
public extension FwiOperation {

    /** Execute business with completion closure. */
    public func executeWithCompletion(completion: (() -> Void)?) {
        super.completionBlock = completion
        self.execute()
    }
}


// Delegate
@objc
public protocol FwiOperationDelegate {

    /** Notify delegate this operation will start. */
    optional func operationWillStart(operation: FwiOperation)
    /** Notify delegate this operation was cancelled. */
    optional func operationDidCancel(operation: FwiOperation)
    /** Notify delegate that this operation finished. */
    optional func operationDidFinish(operation: FwiOperation, withState state: UInt8, userInfo info: [String : AnyObject]?)
}