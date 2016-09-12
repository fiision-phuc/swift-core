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

import UIKit
import Foundation


public final class FwiNetworkManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    // MARK: Class's properties
    fileprivate var networkCounter: NSInteger = 0 {
        didSet {
            if networkCounter > 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

    fileprivate lazy var cache: URLCache = {
        return URLCache.shared
    }()

    fileprivate lazy var session: Foundation.URLSession = {
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
    public func sendRequest(_ request: URLRequest, completion c: RequestCompletion? = nil) {
        var request = request

        // Add additional content negotiation
        if let cached = cache.cachedResponse(for: request)?.response as? HTTPURLResponse, let modifiedSince = cached.allHeaderFields["Date"] as? String {
            request.setValue(modifiedSince, forHTTPHeaderField: "If-Modified-Since")
        }

        // Turn on activity indicator
        networkCounter += 1

        // Create new task
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            var statusCode = FwiNetworkStatus.Unknown
            var error = error
            
            // Turn off activity indicator if neccessary
            self?.networkCounter -= 1
            
            // Obtain HTTP status
            if let err = error as? NSError {
                statusCode = FwiNetworkStatus(rawValue: Int32(err.code))
            }
            
            /* Condition validation: Validate HTTP response instance */
            guard let httpResponse = response as? HTTPURLResponse else {
                c?(nil, error as NSError?, statusCode, nil)
                return
            }
            statusCode = FwiNetworkStatus(rawValue: Int32(httpResponse.statusCode))
            
            // Validate HTTP status
            if !FwiNetworkStatusIsSuccces(statusCode) {
                error = self?.generateError(request as URLRequest, statusCode: statusCode)
            }
            self?.consoleError(request as URLRequest, data: data, error: error as NSError?, statusCode: statusCode)
            
            // Validate content negotiation
          
            if let d = data, let cacheControl = (httpResponse.allHeaderFields["Cache-Control"] as? String)?.lowercased() , cacheControl.hasPrefix("public") && statusCode.rawValue != 304 {
                // Remove previous cache, remove it anyways
                self?.cache.removeCachedResponse(for: request as URLRequest)
                self?.cache.storeCachedResponse(CachedURLResponse(response: httpResponse, data: d), for: request as URLRequest)
            }
            
            // Load cache if http status is 304 or offline
            if let cached = self?.cache.cachedResponse(for: request as URLRequest) , statusCode == .NotConnectedToInternet || statusCode.rawValue == 304 {
                c?(cached.data, nil, FwiNetworkStatus(rawValue: 200), httpResponse)
                return
            }
            c?(data, error as NSError?, statusCode, httpResponse)
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
            self?.consoleError(request as URLRequest, data: nil, error: error as NSError?, statusCode: statusCode)
            c?(location, error as NSError?, statusCode, httpResponse)
        }
        task.resume()
    }

    /** Cancel all running Task. **/
    public func cancelTasks() {
        if #available(iOS 9.0, *) {
            session.getAllTasks { (tasks) in
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
    fileprivate func consoleError(_ request: URLRequest, data d: Data?, error e: NSError?, statusCode s: FwiNetworkStatus) {
        if let err = e, let url = request.url, let host = url.host, let method = request.httpMethod {
            let domain     = "Domain     : \(host)\n"
            let url        = "HTTP Url   : \(url)\n"
            let method     = "HTTP Method: \(method)\n"
            let status     = "HTTP Status: \(s.rawValue) (\(err.localizedDescription))\n"
            let dataString = "\(d?.toString() ?? "")"

            FwiLog("\n\(domain)\(url)\(method)\(status)\(dataString)")
        }
    }

    /** Generate network error. */
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
    
   
    @nonobjc public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust , challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }


    // MARK: NSURLSessionTaskDelegate's members
    @nonobjc public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest) -> Void) {
        completionHandler(request)
    }
}


// MARK: Singleton
public extension FwiNetworkManager {
    fileprivate static let instance = FwiNetworkManager()

    /** Get singleton network manager. */
    public class func sharedInstance() -> FwiNetworkManager {
        return instance
    }
}


// MARK: Completion definition
public typealias RequestCompletion = (_ data: Data?, _ error: NSError?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> ()
public typealias DownloadCompletion = (_ location: URL?, _ error: NSError?, _ statusCode: FwiNetworkStatus, _ response: HTTPURLResponse?) -> ()
