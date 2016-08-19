//  Project name: FwiCore
//  File name   : FwiNetworkManager.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 4/13/14
//  Version     : 1.20
//  --------------------------------------------------------------
//  Copyright (C) 2012, 2015 Fiision Studio.
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


public final class FwiNetworkManager: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {

    // MARK: Class's properties
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
    public func sendRequest(request: NSURLRequest?, completion c: RequestCompletion? = nil) {
        /* Condition validation */
        guard let r = request else {
            c?(data: nil, error: nil, statusCode: 400, response: nil)
            return
        }
    }

    /** Download resource from server. */
    public func downloadResource(request: NSURLRequest?, completion c: DownloadCompletion? = nil) {
        /* Condition validation */
        guard let r = request else {
            c?(location: nil, error: nil, statusCode: 400, response: nil)
            return
        }
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
public typealias RequestCompletion = (data: NSData?, error: NSError?, statusCode: Int, response: NSHTTPURLResponse?) -> ()
public typealias DownloadCompletion = (location: NSURL?, error: NSError?, statusCode: Int, response: NSHTTPURLResponse?) -> ()
