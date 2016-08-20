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


public final class FwiNetworkManager: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {

    // MARK: Class's properties
    private var networkCounter: NSInteger = 0 {
        didSet {
            if networkCounter > 0 {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
    
    private lazy var cache: NSURLCache = {
        return NSURLCache.sharedURLCache()
    }()

    private lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration, delegate: self, delegateQueue: operationQueue)
    }()

    private lazy var configuration: NSURLSessionConfiguration = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()

        // Config request policy
        config.allowsCellularAccess = true
        config.timeoutIntervalForRequest = 60.0
        config.timeoutIntervalForResource = 60.0
        config.networkServiceType = .NetworkServiceTypeBackground

        // Config cache policy
        config.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        config.URLCache = self.cache

        return config
    }()


    // MARK: Class's public methods
    public func prepareRequest(url: NSURL?, requestMethod method: FwiHttpMethod = .Get, queryParams params: [String:String]? = nil) -> NSURLRequest? {
        /* Condition validation */
        guard let u = url else {
            return nil
        }

        let request = FwiRequest(url: u, httpMethod: method)
        params?.forEach({
            request.addFormParam(FwiFormParam(key: $0, value: $1))
        })
        return request
    }

    /** Send request to server. */
    public func sendRequest(request: NSURLRequest, completion c: RequestCompletion? = nil) {
        // Check request instance
        if let r = request as? FwiRequest {
            r.prepare()
            
            // Add additional content negotiation
            if let cached = cache.cachedResponseForRequest(request)?.response as? NSHTTPURLResponse, modifiedSince = cached.allHeaderFields["Date"] as? String {
                r.setValue(modifiedSince, forHTTPHeaderField: "If-Modified-Since")
            }
        }
        
        // Turn on activity indicator
        networkCounter += 1
        
        // Create new task
        let task = session.dataTaskWithRequest(request) { [weak self] (data, response, error) in
            var statusCode = NetworkStatus.Unknown
            var error = error
            
            // Turn off activity indicator if neccessary
            self?.networkCounter -= 1
            
            // Obtain HTTP status
            if let err = error {
                statusCode = NetworkStatus(rawValue: Int32(err.code))
            }
            
            /* Condition validation: Validate HTTP response instance */
            guard let httpResponse = response as? NSHTTPURLResponse else {
                c?(data: nil, error: error, statusCode: statusCode, response: nil)
                return
            }
            statusCode = NetworkStatus(rawValue: Int32(httpResponse.statusCode))
            
            // Validate HTTP status
            if !FwiNetworkStatusIsSuccces(statusCode) {
                error = self?.generateError(request, statusCode: statusCode)
            }
            self?.consoleError(request, data: data, error: error, statusCode: statusCode)
            
            // Validate content negotiation
            if let d = data, cacheControl = httpResponse.allHeaderFields["Cache-Control"]?.lowercaseString where cacheControl.hasPrefix("public") && statusCode.rawValue != 304 {
                // Remove previous cache, remove it anyways
                self?.cache.removeCachedResponseForRequest(request)
                self?.cache.storeCachedResponse(NSCachedURLResponse(response: httpResponse, data: d), forRequest: request)
            }
    
            // Load cache if http status is 304 or offline
            if let cached = self?.cache.cachedResponseForRequest(request) where statusCode == .NotConnectedToInternet || statusCode.rawValue == 304 {
                c?(data: cached.data, error: nil, statusCode: NetworkStatus(rawValue: 200), response: httpResponse)
                return
            }
            c?(data: data, error: error, statusCode: statusCode, response: httpResponse)
        }
        task.resume()
    }

    /** Download resource from server. */
    public func downloadResource(request: NSURLRequest, completion c: DownloadCompletion? = nil) {
        // Check request instance
        if let r = request as? FwiRequest {
            r.prepare()
        }
        
        // Turn on activity indicator
        networkCounter += 1
        
        // Create new task
        let task = session.downloadTaskWithRequest(request) { [weak self] (location, response, error) in
            var statusCode = NetworkStatus.Unknown
            var error = error
            
            // Turn off activity indicator if neccessary
            self?.networkCounter -= 1
            
            /* Condition validation: Validate HTTP response instance */
            guard let httpResponse = response as? NSHTTPURLResponse else {
                c?(location: nil, error: error, statusCode: statusCode, response: nil)
                return
            }
            
            // Obtain HTTP status
            if let err = error {
                statusCode = NetworkStatus(rawValue: Int32(err.code))
            } else {
                statusCode = NetworkStatus(rawValue: Int32(httpResponse.statusCode))
            }
            
            // Validate HTTP status
            if !FwiNetworkStatusIsSuccces(statusCode) {
                error = self?.generateError(request, statusCode: statusCode)
            }
            self?.consoleError(request, data: nil, error: error, statusCode: statusCode)
            c?(location: location, error: error, statusCode: statusCode, response: httpResponse)
        }
        task.resume()
    }

    /** Cancel all running Task. **/
    public func cancelTasks() {
        if #available(iOS 9.0, *) {
            session.getAllTasksWithCompletionHandler { (tasks) in
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
    private func consoleError(request: NSURLRequest, data d: NSData?, error e: NSError?, statusCode s: NetworkStatus) {
        if let err = e, url = request.URL, host = url.host, method = request.HTTPMethod {
            let domain     = "Domain     : \(host)\n"
            let url        = "HTTP Url   : \(url)\n"
            let method     = "HTTP Method: \(method)\n"
            let status     = "HTTP Status: \(s.rawValue) (\(err.localizedDescription))\n"
            let dataString = "\(d?.toString() ?? "")"
            
            print("\n\(domain)\(url)\(method)\(status)\(dataString)")
        }
    }

    /** Generate network error. */
    private func generateError(request: NSURLRequest, statusCode s: NetworkStatus) -> NSError {
        let userInfo = [NSURLErrorFailingURLErrorKey:request.URL?.description ?? "",
                        NSURLErrorFailingURLStringErrorKey:request.URL?.description ?? "",
                        NSLocalizedDescriptionKey:NSHTTPURLResponse.localizedStringForStatusCode(Int(s.rawValue))]
        
        return NSError(domain: NSURLErrorDomain, code: Int(s.rawValue), userInfo: userInfo)
    }
    
    
    // MARK: NSURLSessionDelegate's members
    public func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        if let err = error {
            FwiLog("\(err)")
        }
    }
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust where challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = NSURLCredential(forTrust: serverTrust)
            completionHandler(.UseCredential, credential)
        } else {
            completionHandler(.CancelAuthenticationChallenge, nil)
        }
    }
    
    
    // MARK: NSURLSessionTaskDelegate's members
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
        completionHandler(request)
    }
}


// MARK: Singleton
public extension FwiNetworkManager {
    private static let instance = FwiNetworkManager()

    /** Get singleton network manager. */
    public class func sharedInstance() -> FwiNetworkManager {
        return instance
    }
}


// MARK: Completion definition
public typealias RequestCompletion = (data: NSData?, error: NSError?, statusCode: NetworkStatus, response: NSHTTPURLResponse?) -> ()
public typealias DownloadCompletion = (location: NSURL?, error: NSError?, statusCode: NetworkStatus, response: NSHTTPURLResponse?) -> ()
