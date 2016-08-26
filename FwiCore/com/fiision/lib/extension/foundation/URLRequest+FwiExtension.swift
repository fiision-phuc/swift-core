//  Project name: FwiCore
//  File name   : URLRequest+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/3/14
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

import UIKit
import Foundation


// Creation
public extension URLRequest {

    public init(requestURL url: URL, requestMethod method: FwiHttpMethod = .get, extraHeaders headers: [String:String]? = nil, rawParam param: FwiDataParam? = nil) {
        self.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0)

        defineHTTPMethod(method)
        definePrefixHeaders()
        defineUserAgent()

        headers?.forEach({
            setValue($0, forHTTPHeaderField: $1)
        })

        if let p = param {
            httpBody = p.data
            setValue(p.contentType, forHTTPHeaderField: "Content-Type")
            setValue("\(p.data.count)", forHTTPHeaderField: "Content-Length")
        }
    }

    public init(requestURL url: URL, requestMethod method: FwiHttpMethod = .get, extraHeaders headers: [String:String]? = nil, queryParams params: [String:String]? = nil, fileParams files: [FwiMultipartParam]? = nil) {
        self.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0)

        defineHTTPMethod(method)
        definePrefixHeaders()
        defineUserAgent()

        headers?.forEach({
            setValue($0, forHTTPHeaderField: $1)
        })

        generateRequestForm(method, queryParams: params, fileParams: files)
    }
}

public extension URLRequest {

    /** Define HTTP request method. */
    fileprivate mutating func defineHTTPMethod(_ method: FwiHttpMethod) {
        switch method {
        case .copy:
            httpMethod = "COPY"
            break

        case .delete:
            httpMethod = "DELETE"
            break

        case .head:
            httpMethod = "HEAD"
            break

        case .link:
            httpMethod = "LINK"
            break

        case .options:
            httpMethod = "OPTIONS"
            break

        case .patch:
            httpMethod = "PATCH"
            break

        case .post:
            httpMethod = "POST"
            break

        case .purge:
            httpMethod = "PURGE"
            break

        case .put:
            httpMethod = "PUT"
            break

        case .unlink:
            httpMethod = "UNLINK"
            break
            
        default:
            httpMethod = "GET"
            break
        }
    }

    /** Define prefix HTTP headers. */
    fileprivate mutating func definePrefixHeaders() {
        if value(forHTTPHeaderField: "Accept") == nil {
            setValue("*/*", forHTTPHeaderField: "Accept")
        }
        if value(forHTTPHeaderField: "Accept-Charset") == nil {
            setValue("UTF-8", forHTTPHeaderField: "Accept-Charset")
        }
        if value(forHTTPHeaderField: "Connection") == nil {
            setValue("close", forHTTPHeaderField: "Connection")
        }
    }

    /** Define user agent. */
    fileprivate mutating func defineUserAgent() {
        let deviceInfo = UIDevice.current
        let bundleInfo = Bundle.main.infoDictionary
        let bundleVersion = (bundleInfo?[kCFBundleVersionKey as String] as? String) ?? ""
        let bundleIdentifier = (bundleInfo?[kCFBundleIdentifierKey as String] as? String) ?? ""

        let userAgent = "\(bundleIdentifier)/\(bundleVersion) (\(deviceInfo.model); iOS \(deviceInfo.systemVersion); Scale/\(UIScreen.main.scale))"
        setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }

    /** Generate HTTP request form. */
    fileprivate mutating func generateRequestForm(_ method: FwiHttpMethod, queryParams params: [String:String]?, fileParams files: [FwiMultipartParam]?) {
        switch method {

        case .get:
            if let params = params, params.count > 0 {
                var form = [FwiFormParam]()
                params.forEach({
                    form.append(FwiFormParam(key: $0, value: $1))
                })

                let query = form.map{$0.description}.joined(separator: "&")
                if let url = url?.absoluteString {
                    self.url = URL(string: "\(url)?\(query)")
                }
            }
            break

        case .patch, .post, .put:
            if params != nil && files == nil {
                setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                if let params = params, params.count > 0 {
                    var form = [FwiFormParam]()
                    params.forEach({
                        form.append(FwiFormParam(key: $0, value: $1))
                    })

                    let query = form.map{$0.description}.joined(separator: "&")
                    if let data = query.toData() {
                        setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
                        httpBody = data
                    }
                }
            } else {
                var body = Data()
                let boundary = "----------\(Date().timeIntervalSince1970)"
                setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

                // Multi files
                files?.forEach({
                    if let
                        boundaryData = "\r\n--\(boundary)\r\n".toData(),
                        let contentType = "Content-Type: \($0.contentType)\r\n\r\n".toData(),
                        let contentDisposition = "Content-Disposition: form-data; name=\"\($0.name)\"; filename=\"\($0.fileName)\"\r\n".toData() {

                        body.append(boundaryData)
                        body.append(contentDisposition)
                        body.append(contentType)
                        body.append($0.contentData as Data)
                    }
                })

                // Multi params
                params?.forEach({
                    if let
                        contentData = $0.value.toData(),
                        let boundaryData = "\r\n--\(boundary)\r\n".toData(),
                        let contentDisposition = "Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n".toData() {

                        body.append(boundaryData)
                        body.append(contentDisposition)
                        body.append(contentData)
                    }
                })

                // Finalize request
                if let boundaryData = "\r\n--\(boundary)\r\n".toData() {
                    body.append(boundaryData)
                }

                setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
                httpBody = body
            }
            break
            
        default:
            break
        }
    }
}
