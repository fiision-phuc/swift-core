//  Project name: FwiCore
//  File name   : FwiNetworkManager.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 4/13/14
//  Version     : 1.20
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
#if !RX_NO_MODULE
    import RxCocoa
    import RxSwift
#endif


public final class FwiNetworkManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    // MARK: Completion definition
    public typealias DownloadCompletion = (_ location: URL?, _ error: NSError?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> Void
    public typealias RequestCompletion = (_ data: Data?, _ error: Error?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> Void
    
    // MARK: Singleton instance
    public static let instance = FwiNetworkManager()
    
    // MARK: Class's properties
    fileprivate var cache = URLCache.shared
    fileprivate var networkCounter: NSInteger = 0 {
        didSet {
            #if os(iOS)
                if networkCounter > 0 {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                } else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            #endif
        }
    }
    
    fileprivate lazy var session: URLSession = {
        return Foundation.URLSession(configuration: self.configuration, delegate: self, delegateQueue: operationQueue)
    }()
    
    fileprivate lazy var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default

        // Config request policy
        config.allowsCellularAccess = true
        config.timeoutIntervalForRequest = 60.0
        config.timeoutIntervalForResource = 60.0
        config.networkServiceType = .background

        // Config cache policy
        config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        config.urlCache = self.cache

        return config
    }()

    // MARK: Class's public methods
    public func send(_ request: URLRequest, completion c: @escaping RequestCompletion) {
        // Turn on activity indicator
        networkCounter += 1
        
        // Add additional content negotiation
        var request = request
        if
            let cached = cache.cachedResponse(for: request)?.response as? HTTPURLResponse,
            let modifiedSince = cached.allHeaderFields["Date"] as? String
        {
            request.setValue(modifiedSince, forHTTPHeaderField: "If-Modified-Since")
        }

        // Create new task
        let task = session.dataTask(with: request) { [weak self] (data, response, err) in
            // Turn off activity indicator if neccessary
            self?.networkCounter -= 1
            var err = err
            
            // Perform casting
            guard let httpResponse = response as? HTTPURLResponse else {
                c(nil, err, FwiNetworkStatus.BadServerResponse, nil)
                return
            }
            
            // Obtain HTTP status
            var statusCode = FwiNetworkStatus.Unknown
            if let err = err as? NSError {
                statusCode = FwiNetworkStatus(rawValue: Int32(err.code))
            } else {
                statusCode = FwiNetworkStatus(rawValue: Int32(httpResponse.statusCode))
            }
            
            // Validate HTTP status
            if !FwiNetworkStatusIsSuccces(statusCode) {
                err = self?.generateError(request, statusCode: statusCode)
            }
            self?.consoleError(request, data: data, error: err, statusCode: statusCode)
            
            // Remove previous cache, remove it anyways
            if
                let d = data,
                let cacheControl = (httpResponse.allHeaderFields["Cache-Control"] as? String)?.lowercased() , cacheControl.hasPrefix("public") && statusCode.rawValue != 304
            {
                self?.cache.removeCachedResponse(for: request)
                self?.cache.storeCachedResponse(CachedURLResponse(response: httpResponse, data: d), for: request)
            }
            
            // Load cache if http status is 304 or offline
            if let cached = self?.cache.cachedResponse(for: request) , statusCode == .NotConnectedToInternet || statusCode.rawValue == 304 {
                c(cached.data, err, FwiNetworkStatus(rawValue: 200), httpResponse)
                return
            }
            c(data, err, statusCode, httpResponse)
        }
        
        task.resume()
    }

    /** Download resource from server. */
    public func downloadResource(_ request: URLRequest, completion c: DownloadCompletion? = nil) {
        // Turn on activity indicator
        networkCounter += 1

        // Create new task
        let task = session.downloadTask(with: request) { [weak self] (location, response, error) in
            var statusCode = FwiNetworkStatus.Unknown
            var error = error

            // Turn off activity indicator if neccessary
            self?.networkCounter -= 1

            /* Condition validation: Validate HTTP response instance */
            guard let httpResponse = response as? HTTPURLResponse else {
                c?(nil, error as NSError?, statusCode, nil)
                return
            }

            // Obtain HTTP status
            if let err = error as? NSError {
                statusCode = FwiNetworkStatus(rawValue: Int32(err.code))
            } else {
                statusCode = FwiNetworkStatus(rawValue: Int32(httpResponse.statusCode))
            }

            // Validate HTTP status
            if !FwiNetworkStatusIsSuccces(statusCode) {
                error = self?.generateError(request as URLRequest, statusCode: statusCode)
            }
            self?.consoleError(request as URLRequest, data: nil, error: error, statusCode: statusCode)
            c?(location, error as NSError?, statusCode, httpResponse)
        }
        task.resume()
    }

    /** Cancel all running Task. **/
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


    // MARK: Class's private methods
    /// Output error to console.
    ///
    /// - parameter request (required): request
    /// - parameter data (required): response's data
    /// - parameter error (required): response's error
    /// - parameter statusCode (required): network's status
    fileprivate func consoleError(_ request: URLRequest, data d: Data?, error e: Error?, statusCode s: FwiNetworkStatus) {
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

    /// Generate network error.
    ///
    /// - parameter request (required): request
    /// - parameter statusCode (required): network's status
    fileprivate func generateError(_ request: URLRequest, statusCode s: FwiNetworkStatus) -> NSError {
        let userInfo = [NSURLErrorFailingURLErrorKey:request.url?.description ?? "",
                        NSURLErrorFailingURLStringErrorKey:request.url?.description ?? "",
                        NSLocalizedDescriptionKey:HTTPURLResponse.localizedString(forStatusCode: Int(s.rawValue))]

        return NSError(domain: NSURLErrorDomain, code: Int(s.rawValue), userInfo: userInfo)
    }

    // MARK: NSURLSessionDelegate's members
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let err = error {
            FwiLog("\(err)")
        }
    }
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust , challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    // MARK: NSURLSessionTaskDelegate's members
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        FwiLog("Cache Response")
    }
}
