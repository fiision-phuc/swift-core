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

struct ConsoleNetwork {
    /// - parameter request (required): request
    /// - parameter statusCode (required): network's status
    static func generateError(_ request: URLRequest, statusCode s: FwiNetworkStatus) -> NSError {
        let userInfo = [NSURLErrorFailingURLErrorKey:request.url?.description ?? "",
                        NSURLErrorFailingURLStringErrorKey:request.url?.description ?? "",
                        NSLocalizedDescriptionKey:s.description]
        
        return NSError(domain: NSURLErrorDomain, code: s.rawValue, userInfo: userInfo)
    }
    
    /// Output error to console.
    ///
    /// - parameter request (required): request
    /// - parameter data (required): response's data
    /// - parameter error (required): response's error
    /// - parameter statusCode (required): network's status
    static func consoleError(_ request: URLRequest, data d: Data?, error e: Error?, statusCode s: FwiNetworkStatus) {
        guard let err = e as? NSError, let url = request.url, let host = url.host, let method = request.httpMethod else {
            return
        }
        
        let domain     = "Domain     : \(host)\n"
        let urlString  = "HTTP Url   : \(url)\n"
        let httpMethod = "HTTP Method: \(method)\n"
        let status     = "HTTP Status: \(s.rawValue) (\(err.localizedDescription))\n"
        let dataString = "\(d?.toString() ?? "")"
        
        FwiLog("\n\(domain)\(urlString)\(httpMethod)\(status)\(dataString)")
    }
}


public typealias RequestCompletion = (_ data: Data?, _ error: Error?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> Void
public typealias DownloadCompletion = (_ location: URL?, _ error: Error?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> Void

public protocol FwiNetworkProtocol {
    var session: URLSession { get }
    var networkCounter: Int { get set }
}

public extension FwiNetworkProtocol where Self: FwiNetwork{

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
                error = ConsoleNetwork.generateError(r as URLRequest, statusCode: statusCode)
            }
            ConsoleNetwork.consoleError(r, data: nil, error: error, statusCode: statusCode)
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
                error = ConsoleNetwork.generateError(r as URLRequest, statusCode: statusCode)
            }
            ConsoleNetwork.consoleError(r, data: data, error: error, statusCode: statusCode)
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
