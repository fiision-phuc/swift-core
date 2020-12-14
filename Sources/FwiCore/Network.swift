//  File name   : Network.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 4/13/14
//  --------------------------------------------------------------
//  Copyright © 2012, 2019 Fiision Studio. All Rights Reserved.
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

#if canImport(Alamofire)
    import Alamofire
    import Foundation

    public typealias DownloadCompletion = (_ location: URL?, _ error: Error?, _ response: HTTPURLResponse?) -> Void
    public typealias RequestCompletion = (_ data: Data?, _ error: Error?, _ response: HTTPURLResponse?) -> Void

    public struct Network {
        public static var manager = Session.default

        /// Download resource from server.
        ///
        /// - parameters:
        ///   - request {String} (an endpoint)
        ///   - method {HTTPMethod} (a HTTP method)
        ///   - params {[String:String]} (a query params)
        ///   - encoding {ParameterEncoding} (define how to encode query params)
        ///   - headers {[String: String]} (additional headers)
        ///   - completion (required): call back function
        @discardableResult
        public static func download(_ resourceURL: URLConvertible,
                                    method: HTTPMethod = .get,
                                    params: [String: Any]? = nil,
                                    paramEncoding: ParameterEncoding = URLEncoding.default,
                                    headers: [String: String]? = nil,
                                    destinationURL: URLConvertible? = nil,
                                    completion: @escaping DownloadCompletion) -> DownloadRequest
        {
            let des = destinationURL
            let destination: DownloadRequest.Destination = { tempURL, response in
                if let d = des, let destinationURL = try? d.asURL() {
                    let options: DownloadRequest.Options = [.createIntermediateDirectories, .removePreviousFile]
                    return (destinationURL, options)
                }
                return (tempURL, [])
            }

            var httpHeaders: HTTPHeaders?
            if let headers = headers {
                httpHeaders = HTTPHeaders(headers)
            }

            let task = manager.download(resourceURL, method: method, parameters: params, encoding: paramEncoding, headers: httpHeaders, to: { (tempURL, response) -> (URL, DownloadRequest.Options) in
                destination(tempURL, response)
            })
            task.validate(statusCode: 200 ..< 300)
            task.response { r in
                completion(r.fileURL, r.error, r.response)
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
        public static func send(_ requestURL: URLConvertible,
                                method: HTTPMethod = .get,
                                params: [String: Any]? = nil,
                                paramEncoding: ParameterEncoding = URLEncoding.default,
                                headers: [String: String]? = nil,
                                completion c: @escaping RequestCompletion) -> DataRequest
        {
            var httpHeaders: HTTPHeaders?
            if let headers = headers {
                httpHeaders = HTTPHeaders(headers)
            }

            let task = manager.request(requestURL, method: method, parameters: params, encoding: paramEncoding, headers: httpHeaders)
            task.validate(statusCode: 200 ..< 300)
            task.response { r in
                if FwiCore.debug {
                    task.cURLDescription { curlString in
                        let separator = "--------------------------------------------------------------------------------"
                        let string = "\n\(separator)\n\(curlString)\n\n[RESPONSE]\n\(r.data?.toString() ?? "")\n\(separator)"
                        Log.debug(string)
                    }
                }
                c(r.data, r.error, r.response)
            }
            return task
        }

        /// Cancel all running Tasks.
        public static func cancelTasks() {
            let session = manager.session
            func excutionCancel(_ tasks: [URLSessionTask]) {
                tasks.forEach { $0.cancel() }
            }

            if #available(OSX 10.11, iOS 9.0, *) {
                session.getAllTasks(completionHandler: excutionCancel)
            } else {
                session.getTasksWithCompletionHandler { sessionTasks, uploadTasks, downloadTasks in
                    let allTask: [[URLSessionTask]] = [sessionTasks, uploadTasks, downloadTasks]
                    excutionCancel(allTask.flatMap { $0 })
                }
            }
        }

        /// Cancel all data Tasks.
        public static func cancelDataTasks() {
            let session = manager.session
            session.getTasksWithCompletionHandler { sessionTasks, _, _ in
                sessionTasks.forEach {
                    $0.cancel()
                }
            }
        }

        /// Cancel all download Tasks.
        public static func cancelDownloadTasks() {
            let session = manager.session
            session.getTasksWithCompletionHandler { _, _, downloadTasks in
                downloadTasks.forEach {
                    $0.cancel()
                }
            }
        }

        /// Cancel all upload Tasks.
        public static func cancelUploadTasks() {
            let session = manager.session
            session.getTasksWithCompletionHandler { _, uploadTasks, _ in
                uploadTasks.forEach {
                    $0.cancel()
                }
            }
        }
    }
#endif
