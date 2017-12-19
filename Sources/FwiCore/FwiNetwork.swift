//  Project name: FwiCore
//  File name   : FwiNetwork.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 4/13/14
//  --------------------------------------------------------------
//  Copyright © 2012, 2017 Fiision Studio. All Rights Reserved.
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
import Alamofire


public typealias DownloadCompletion = (_ location: URL?, _ error: Error?, _ response: HTTPURLResponse?) -> Void
public typealias RequestCompletion = (_ data: Data?, _ error: Error?, _ response: HTTPURLResponse?) -> Void


public struct FwiNetwork {
    public static var manager = SessionManager.`default`


    /// Download resource from server.
    ///
    /// @params
    /// - request {String} (an endpoint)
    /// - method {HTTPMethod} (a HTTP method)
    /// - params {[String:String]} (a query params)
    /// - encoding {ParameterEncoding} (define how to encode query params)
    /// - headers {[String: String]} (additional headers)
    ///
    /// - parameter completion (required): call back function
    @discardableResult
    public static func download(resource r: String?, method m: HTTPMethod = .get, params p: [String:String]? = nil, encoding e: ParameterEncoding = URLEncoding.`default`, headers h: [String: String]? = nil, completion c: @escaping DownloadCompletion) -> DownloadRequest? {
        /* Condition validation: validate endpoint */
        guard let url = r else {
            return nil
        }

        let task = manager.download(url, method: m, parameters: p, encoding: e, headers: h, to: nil)
        task.validate(statusCode: 200 ..< 300)
        task.response { (r) in
            c(r.temporaryURL, r.error, r.response)
        }
        return task
    }

    /// Send request to server.
    ///
    /// @params
    /// - request {String} (an endpoint)
    /// - method {HTTPMethod} (a HTTP method)
    /// - params {[String:String]} (a query params)
    /// - encoding {ParameterEncoding} (define how to encode query params)
    /// - headers {[String: String]} (additional headers)
    ///
    /// - parameter completion (required): call back function
    @discardableResult
    public static func send(request r: String?, method m: HTTPMethod = .get, params p: [String:String]? = nil, encoding e: ParameterEncoding = URLEncoding.`default`, headers h: [String: String]? = nil, completion c: @escaping RequestCompletion) -> DataRequest? {
        /* Condition validation: validate endpoint */
        guard let url = r else {
            return nil
        }

        let task = manager.request(url, method: m, parameters: p, encoding: e, headers: h)
        task.validate(statusCode: 200 ..< 300)
        task.response { (r) in
            c(r.data, r.error, r.response)
        }
        return task
    }

    /// Cancel all running Tasks.
    public static func cancelTasks() {
        let session = SessionManager.`default`.session

        if #available(OSX 10.11, iOS 9.0, *) {
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

    /// Cancel all data Tasks.
    public static func cancelDataTasks() {
        let session = SessionManager.`default`.session
        session.getTasksWithCompletionHandler({ (sessionTasks, _, _) in
            sessionTasks.forEach({
                $0.cancel()
            })
        })
    }

    /// Cancel all download Tasks.
    public static func cancelDownloadTasks() {
        let session = SessionManager.`default`.session
        session.getTasksWithCompletionHandler({ (_, _, downloadTasks) in
            downloadTasks.forEach({
                $0.cancel()
            })
        })
    }

    /// Cancel all upload Tasks.
    public static func cancelUploadTasks() {
        let session = SessionManager.`default`.session
        session.getTasksWithCompletionHandler({ (_, uploadTasks, _) in
            uploadTasks.forEach({
                $0.cancel()
            })
        })
    }
}

