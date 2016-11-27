//  Project name: FwiCore
//  File name   : FwiNetworkProtocol.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 10/31/16
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


public typealias DownloadCompletion = (_ location: URL?, _ error: Error?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> Void
public typealias RequestCompletion = (_ data: Data?, _ error: Error?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> Void

/// FwiNetworkProtocol defines required properties for network manager.
public protocol FwiNetworkProtocol {
    var session: URLSession { get }
    var networkCounter: Int { get set }
}

public extension FwiNetworkProtocol where Self: FwiNetwork {

    /// Download resource from server.
    ///
    /// - parameter request (required): request
    /// - parameter completion (required): call back function
    @discardableResult
    public func download(resource r: URLRequest, completion c: @escaping DownloadCompletion) -> URLSessionDownloadTask {
        // Turn on activity indicator
        self.networkCounter += 1

        // Create new task
        let task = session.downloadTask(with: r) { [weak self](location, response, err) in
            // Turn off activity indicator if neccessary
            self?.networkCounter -= 1
            var error = err
            
            var statusCode = FwiNetworkStatus.unknown
            if let error = error as? NSError {
                statusCode = FwiNetworkStatus(rawValue: error.code)
            }
            
            /* Condition validation: Validate HTTP response instance */
            guard let httpResponse = response as? HTTPURLResponse else {
                c(nil, error, statusCode, nil)
                return
            }
            statusCode = FwiNetworkStatus(rawValue: httpResponse.statusCode)
            
            // Validate HTTP status
            if !FwiNetworkStatusIsSuccces(statusCode) {
                error = FwiConsole.generateError(withRequest: r as URLRequest, statusCode: statusCode)
            }
            FwiConsole.consoleError(withRequest: r, data: nil, error: error, statusCode: statusCode)
            c(location, error, statusCode, httpResponse)
        }

        task.resume()
        return task
    }
    
    // MARK: Class's public methods
    /// Send request to server.
    ///
    /// - parameter request (required): request
    /// - parameter completion (required): call back function
    @discardableResult
    public func send(request r: URLRequest, completion c: @escaping RequestCompletion) -> URLSessionDataTask {
        // Turn on activity indicator
        self.networkCounter += 1
        
        // Create new task
        let task = session.dataTask(with: r) { [weak self](data, response, err) in
            // Turn off activity indicator if neccessary
            self?.networkCounter -= 1
            var error = err
            
            var statusCode = FwiNetworkStatus.unknown
            if let error = error as? NSError {
                statusCode = FwiNetworkStatus(rawValue: error.code)
            }

            /* Condition validation: Validate HTTP response instance */
            guard let httpResponse = response as? HTTPURLResponse else {
                c(nil, error, statusCode, nil)
                return
            }
            statusCode = FwiNetworkStatus(rawValue: httpResponse.statusCode)
            
            // Validate HTTP status
            if !FwiNetworkStatusIsSuccces(statusCode) {
                error = FwiConsole.generateError(withRequest: r as URLRequest, statusCode: statusCode)
            }
            FwiConsole.consoleError(withRequest: r, data: data, error: error, statusCode: statusCode)
            c(data, error, statusCode, httpResponse)
        }
        task.resume()
        return task
    }
    
    /// Cancel all running Tasks.
    public func cancelTasks() {
        let manager = FwiNetwork.instance

        if #available(OSX 10.11, iOS 9.0, *) {
            manager.session.getAllTasks { (tasks) in
                tasks.forEach({
                    $0.cancel()
                })
            }
        } else {
            manager.session.getTasksWithCompletionHandler({ (sessionTasks, uploadTasks, downloadTasks) in
                sessionTasks.forEach({
                    $0.cancel()
                })
                
                uploadTasks.forEach({
                    $0.cancel()
                })
                
                downloadTasks.forEach({
                    $0.cancel()
                })
            })
        }
    }
    
    /// Cancel all data Tasks.
    public func cancelDataTasks() {
        session.getTasksWithCompletionHandler({ (sessionTasks, _, _) in
            sessionTasks.forEach({
                $0.cancel()
            })
        })
    }
    
    /// Cancel all download Tasks.
    public func cancelDownloadTasks() {
        session.getTasksWithCompletionHandler({ (_, _, downloadTasks) in
            downloadTasks.forEach({
                $0.cancel()
            })
        })
    }
    
    /// Cancel all upload Tasks.
    public func cancelUploadTasks() {
        session.getTasksWithCompletionHandler({ (_, uploadTasks, _) in
            uploadTasks.forEach({
                $0.cancel()
            })
        })
    }
}
