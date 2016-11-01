//  Project name: FwiCore
//  File name   : FwiNetworkProtocol.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 10/31/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import Foundation


public protocol FwiNetworkProtocol {
    
    typealias DownloadCompletion = (_ location: URL?, _ error: Error?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> Void
    typealias RequestCompletion = (_ data: Data?, _ error: Error?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> Void
}


public extension FwiNetworkProtocol {
    
    // MARK: Class's public methods
    /// Download resource from server.
    ///
    /// - parameter request (required): request
    /// - parameter completion (required): call back function
    @discardableResult
    public func download(resource r: URLRequest, completion c: @escaping DownloadCompletion) -> URLSessionDownloadTask {
        // Turn on activity indicator
        let manager = FwiNetworkManager.instance
//        manager.networkCounter += 1
        
        // Create new task
        let task = manager.session.downloadTask(with: r) { (location, response, err) in
            // Turn off activity indicator if neccessary
//            self?.networkCounter -= 1
            
            var statusCode = FwiNetworkStatus.unknown
            let error = err
            
            /* Condition validation: Validate HTTP response instance */
            guard let httpResponse = response as? HTTPURLResponse else {
                c(nil, error, statusCode, nil)
                return
            }
            
            // Obtain HTTP status
            if let error = error as? NSError {
                statusCode = FwiNetworkStatus(rawValue: error.code)
            } else {
                statusCode = FwiNetworkStatus(rawValue: httpResponse.statusCode)
            }
            
            // Validate HTTP status
//            if !FwiNetworkStatusIsSuccces(statusCode) {
//                error = self?.generateError(r as URLRequest, statusCode: statusCode)
//            }
//            self?.consoleError(r as URLRequest, data: nil, error: error, statusCode: statusCode)
            c(location, err, statusCode, httpResponse)
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
        networkCounter += 1
        
        // Add additional content negotiation
        var request = r
        if let cached = cache.cachedResponse(for: request)?.response as? HTTPURLResponse {
            if let modifiedSince = cached.allHeaderFields["Date"] as? String {
                request.setValue(modifiedSince, forHTTPHeaderField: "If-Modified-Since")
            }
        }
        
        // Create new task
        let task = session.dataTask(with: request) { [weak self] (data, response, err) in
            // Turn off activity indicator if neccessary
            self?.networkCounter -= 1
            var err = err
            
            // Obtain HTTP status
            var statusCode = FwiNetworkStatus.unknown
            if let err = err as? NSError {
                statusCode = FwiNetworkStatus(rawValue: err.code)
            }
            
            // Perform casting
            guard let httpResponse = response as? HTTPURLResponse else {
                c(nil, err, statusCode, nil)
                return
            }
            statusCode = FwiNetworkStatus(rawValue: httpResponse.statusCode)
            
            // Validate HTTP status
            if !FwiNetworkStatusIsSuccces(statusCode) {
                err = self?.generateError(request, statusCode: statusCode)
            }
            self?.consoleError(request, data: data, error: err, statusCode: statusCode)
            
            // Remove previous cache, remove it anyways
            if let cacheControl = httpResponse.allHeaderFields["Cache-Control"] as? String, statusCode.rawValue != 304 {
                let cacheHeader = cacheControl.lowercased()
                if cacheHeader.hasPrefix("public") {
                    if let data = data {
                        self?.cache.removeCachedResponse(for: request)
                        self?.cache.storeCachedResponse(CachedURLResponse(response: httpResponse, data: data), for: request)
                    }
                }
            }
            
            // Load cache if http status is 304 or offline
            if statusCode == .notConnectedToInternet || statusCode.rawValue == 304 {
                if let cached = self?.cache.cachedResponse(for: request) {
                    c(cached.data, err, FwiNetworkStatus(rawValue: 200), httpResponse)
                    return
                }
            }
            c(data, err, statusCode, httpResponse)
        }
        task.resume()
        return task
    }
    
    /// Cancel all running Tasks.
    public func cancelTasks() {
        if #available(OSX 10.11, iOS 9.0, *) {
            self.session.getAllTasks { (tasks) in
                tasks.forEach({
                    $0.cancel()
                })
            }
        } else {
            session.getTasksWithCompletionHandler({ (sessionTasks, uploadTasks, downloadTasks) in
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
