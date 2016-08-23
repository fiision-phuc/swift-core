//  Project name: FwiCore
//  File name   : FwiRequest.swift
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


public final class FwiRequest: NSMutableURLRequest {

    // MARK: Class's properties
    fileprivate var methodType: FwiHttpMethod?

    fileprivate var raw: FwiDataParam?
    fileprivate var form: [FwiFormParam]?
    fileprivate var upload: [FwiMultipartParam]?

    // MARK: Class's public methods
    @discardableResult
    public func prepare() -> UInt {
        // Predefine headers
        self.defineUserAgent()
        if  value(forHTTPHeaderField: "Accept") == nil {
            setValue("*/*", forHTTPHeaderField: "Accept")
        }
        if value(forHTTPHeaderField: "Accept-Charset") == nil {
            setValue("UTF-8", forHTTPHeaderField: "Accept-Charset")
        }
        if value(forHTTPHeaderField: "Connection") == nil {
            setValue("close", forHTTPHeaderField: "Connection")
        }

        /* Condition validation */
        if raw == nil && form == nil && upload == nil {
            return 0
        }

        /* Condition validation: validate method type */
        guard let type = methodType else {
            return 0
        }

        guard let r = raw else {
            switch type {
            case .get:
                let query = form?.map {$0.description}.joined(separator: "&")
                if let url = url?.absoluteString, let q = query {
                    self.url = URL(string: "\(url)?\(q)")
                }
                return 0

            case .patch, .post, .put:
                if form != nil && upload == nil {
                    setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

                    let query = form?.map {$0.description}.joined(separator: "&")
                    if let data = query?.toData() {
                        setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
                        httpBody = data
                        return UInt(data.count)
                    }
                    return 0

                } else {
                    let body = NSMutableData()
                    let boundary = "----------\(Date().timeIntervalSince1970)"
                    setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

                    // Multi files
                    upload?.forEach({
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
                    form?.forEach({
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

                    setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
                    httpBody = body as Data

                    return UInt(body.length)
                }

            default:
                return 0
            }
        }

        // Handle raw data request
        httpBody = r.data as Data
        setValue(r.contentType, forHTTPHeaderField: "Content-Type")
        setValue("\(r.data.count)", forHTTPHeaderField: "Content-Length")

        return UInt(r.data.count)
    }

    /** Set custom data param. */
    public func setDataParam(_ param: FwiDataParam?) {
        /* Condition validation: Validate method type */
        if !(methodType == .post || methodType == .patch || methodType == .put) {
            return
        }
        raw = param
        form = nil
        upload = nil
    }

    /** Add form parameter. */
    public func addFormParam(_ param: FwiFormParam?) {
        self.initializeForm()
        raw = nil

        if let paramsForm = param {
            form?.append(paramsForm)
        }
    }
    public func setFormParam(_ param: FwiFormParam?) {
        form?.removeAll(keepingCapacity: false)
        self.addFormParam(param)
    }
    public func addFormParams(_ params: [FwiFormParam]?) {
        self.initializeForm()
        raw = nil

        params?.forEach() { [weak self] in
            self?.form?.append($0)
        }
    }
    public func setFormParams(_ params: [FwiFormParam]?) {
        form?.removeAll(keepingCapacity: false)
        self.addFormParams(params)
    }

    /** Add multipart parameter. */
    public func addMultipartParam(_ param: FwiMultipartParam?) {
        self.initializeUpload()
        raw = nil

        if let p = param {
            upload?.append(p)
        }
    }
    public func setMultipartParam(_ param: FwiMultipartParam?) {
        upload?.removeAll(keepingCapacity: false)
        self.addMultipartParam(param)
    }
    public func addMultipartParams(_ params: [FwiMultipartParam]?) {
        self.initializeUpload()
        raw = nil

        params?.forEach() { [weak self] in
            self?.upload?.append($0)
        }
    }
    public func setMultipartParams(_ params: [FwiMultipartParam]?) {
        upload?.removeAll(keepingCapacity: false)
        self.addMultipartParams(params)
    }

    // MARK: Class's private methods
    fileprivate func initializeForm() {
        if form != nil {
            return
        }
        form = [FwiFormParam]()
    }
    fileprivate func initializeUpload() {
        if upload != nil {
            return
        }
        upload = [FwiMultipartParam]()
    }

    /** Define user agent for each request. */
    fileprivate func defineUserAgent() {
        let deviceInfo = UIDevice.current
        let bundleInfo = Bundle.main.infoDictionary
        let bundleVersion = (bundleInfo?[kCFBundleVersionKey as String] as? String) ?? ""
        let bundleIdentifier = (bundleInfo?[kCFBundleIdentifierKey as String] as? String) ?? ""

        let userAgent = "\(bundleIdentifier)/\(bundleVersion) (\(deviceInfo.model); iOS \(deviceInfo.systemVersion); Scale/\(UIScreen.main.scale))"
        setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
}


// Creation
public extension FwiRequest {

    // MARK: Class's constructors
    public convenience init(url: URL, httpMethod method: FwiHttpMethod = .get) {
        self.init(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        raw = nil
        form = nil
        upload = nil
        methodType = method

        switch method {
        case .copy:
            self.httpMethod = "COPY"
            break

        case .delete:
            self.httpMethod = "DELETE"
            break

        case .head:
            self.httpMethod = "HEAD"
            break

        case .link:
            self.httpMethod = "LINK"
            break

        case .options:
            self.httpMethod = "OPTIONS"
            break

        case .patch:
            self.httpMethod = "PATCH"
            break

        case .post:
            self.httpMethod = "POST"
            break

        case .purge:
            self.httpMethod = "PURGE"
            break

        case .put:
            self.httpMethod = "PUT"
            break

        case .unlink:
            self.httpMethod = "UNLINK"
            break


        default:
            self.httpMethod = "GET"
            break
        }
    }
}
