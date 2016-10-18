//  Project name: FwiCore
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

#if os(iOS)
    import UIKit
#endif
import Foundation


open class FwiOperation: Operation {
    
    // MARK: Class's constructors
    public override init() {
        super.init()
    }

    // MARK: Class's properties
    public var isLongOperation = false
    public lazy var identifier: String = {
        return String.randomIdentifier() ?? ""
    }()
    
    fileprivate var opFinished = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    fileprivate var opExecuting = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    fileprivate var userInfo: [String: AnyObject]?
    #if os(iOS)
    fileprivate var bgTask: UIBackgroundTaskIdentifier?
    #endif

    // MARK: Class's public methods
    open func businessLogic() {
    }

    // MARK: Class's private methods
    fileprivate func execute() {
        // Always check for cancellation before launching the task.
        if isCancelled {
            operationCompleted()
        } else {
            #if os(iOS)
                // Register bgTask
                bgTask = UIApplication.shared.beginBackgroundTask() {
                    /* Condition validatioN: Is long operation */
                    if self.isLongOperation {
                        return
                    }

                    // Cancel this operation
                    self.cancel()
                    self.operationCompleted()
                }
            #endif

            // Add to operation queue
            operationQueue.addOperation(self)
        }
    }

    /** Called when operation completed. */
    fileprivate func operationCompleted() {
        opExecuting = false
        opFinished = true

        #if os(iOS)
            // Terminate background task
            if let task = bgTask, bgTask != UIBackgroundTaskInvalid {
                UIApplication.shared.endBackgroundTask(task)
                bgTask = UIBackgroundTaskInvalid
            }
        #endif
    }

    // MARK: NSOperation's members
    open override var isAsynchronous: Bool {
        return true
    }
    open override var isExecuting: Bool {
        return opExecuting
    }
    open override var isFinished: Bool {
        return opFinished
    }
    open override var isReady: Bool {
        return true
    }

    open override func start() {
        autoreleasepool { () -> () in
            if !isCancelled {
                opExecuting = true
                businessLogic()
            }
            operationCompleted()
        }
    }
}


// MARK: Extension
public extension FwiOperation {

    /** Execute business with completion closure. */
    public func executeWithCompletion(_ completion:(() -> Void)?) {
        super.completionBlock = completion
        execute()
    }
}


// MARK: Private queue
public var operationQueue: OperationQueue = {
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 5
    operationQueue.qualityOfService = QualityOfService.utility

    return operationQueue
}()
