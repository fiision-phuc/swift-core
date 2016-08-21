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
    private var methodType: FwiHttpMethod?

    private var raw: FwiDataParam?
    private var form: [FwiFormParam]?
    private var upload: [FwiMultipartParam]?

    // MARK: Class's public methods
    public func prepare() -> UInt {
        // Predefine headers
        self.defineUserAgent()
        if  valueForHTTPHeaderField("Accept") == nil {
            setValue("*/*", forHTTPHeaderField: "Accept")
        }
        if valueForHTTPHeaderField("Accept-Charset") == nil {
            setValue("UTF-8", forHTTPHeaderField: "Accept-Charset")
        }
        if valueForHTTPHeaderField("Connection") == nil {
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
            case .Get:
                let query = form?.map {$0.description}.joinWithSeparator("&")
                if let url = URL?.absoluteString, q = query {
                    self.URL = NSURL(string: "\(url)?\(q)")
                }
                return 0

            case .Patch, .Post, .Put:
                if form != nil && upload == nil {
                    setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

                    let query = form?.map {$0.description}.joinWithSeparator("&")
                    if let data = query?.toData() {
                        setValue("\(data.length)", forHTTPHeaderField: "Content-Length")
                        HTTPBody = data
                        return UInt(data.length)
                    }
                    return 0

                } else {
                    let body = NSMutableData()
                    let boundary = "----------\(NSDate().timeIntervalSince1970)"
                    setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

                    // Multi files
                    upload?.forEach({
                        if let
                            boundaryData = "\r\n--\(boundary)\r\n".toData(),
                            contentType = "Content-Type: \($0.contentType)\r\n\r\n".toData(),
                            contentDisposition = "Content-Disposition: form-data; name=\"\($0.name)\"; filename=\"\($0.fileName)\"\r\n".toData() {

                            body.appendData(boundaryData)
                            body.appendData(contentDisposition)
                            body.appendData(contentType)
                            body.appendData($0.contentData)
                        }
                    })

                    // Multi params
                    form?.forEach({
                        if let
                            contentData = $0.value.toData(),
                            boundaryData = "\r\n--\(boundary)\r\n".toData(),
                            contentDisposition = "Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n".toData() {

                            body.appendData(boundaryData)
                            body.appendData(contentDisposition)
                            body.appendData(contentData)
                        }
                    })

                    // Finalize request
                    if let boundaryData = "\r\n--\(boundary)\r\n".toData() {
                        body.appendData(boundaryData)
                    }

                    setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
                    HTTPBody = body

                    return UInt(body.length)
                }

            default:
                return 0
            }
        }

        // Handle raw data request
        HTTPBody = r.data
        setValue(r.contentType, forHTTPHeaderField: "Content-Type")
        setValue("\(r.data.length)", forHTTPHeaderField: "Content-Length")

        return UInt(r.data.length)
    }

    /** Set custom data param. */
    public func setDataParam(param: FwiDataParam?) {
        /* Condition validation: Validate method type */
        if !(methodType == .Post || methodType == .Patch || methodType == .Put) {
            return
        }
        raw = param
        form = nil
        upload = nil
    }

    /** Add form parameter. */
    public func addFormParam(param: FwiFormParam?) {
        self.initializeForm()
        raw = nil

        if let paramsForm = param {
            form?.append(paramsForm)
        }
    }
    public func setFormParam(param: FwiFormParam?) {
        form?.removeAll(keepCapacity: false)
        self.addFormParam(param)
    }
    public func addFormParams(params: [FwiFormParam]?) {
        self.initializeForm()
        raw = nil

        params?.forEach() { [weak self] in
            self?.form?.append($0)
        }
    }
    public func setFormParams(params: [FwiFormParam]?) {
        form?.removeAll(keepCapacity: false)
        self.addFormParams(params)
    }

    /** Add multipart parameter. */
    public func addMultipartParam(param: FwiMultipartParam?) {
        self.initializeUpload()
        raw = nil

        if let p = param {
            upload?.append(p)
        }
    }
    public func setMultipartParam(param: FwiMultipartParam?) {
        upload?.removeAll(keepCapacity: false)
        self.addMultipartParam(param)
    }
    public func addMultipartParams(params: [FwiMultipartParam]?) {
        self.initializeUpload()
        raw = nil

        params?.forEach() { [weak self] in
            self?.upload?.append($0)
        }
    }
    public func setMultipartParams(params: [FwiMultipartParam]?) {
        upload?.removeAll(keepCapacity: false)
        self.addMultipartParams(params)
    }

    // MARK: Class's private methods
    private func initializeForm() {
        if form != nil {
            return
        }
        form = [FwiFormParam]()
    }
    private func initializeUpload() {
        if upload != nil {
            return
        }
        upload = [FwiMultipartParam]()
    }

    /** Define user agent for each request. */
    private func defineUserAgent() {
        let deviceInfo = UIDevice.currentDevice()
        let bundleInfo = NSBundle.mainBundle().infoDictionary
        let bundleVersion = (bundleInfo?[kCFBundleVersionKey as String] as? String) ?? ""
        let bundleIdentifier = (bundleInfo?[kCFBundleIdentifierKey as String] as? String) ?? ""

        let userAgent = "\(bundleIdentifier)/\(bundleVersion) (\(deviceInfo.model); iOS \(deviceInfo.systemVersion); Scale/\(UIScreen.mainScreen().scale))"
        setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
}


// Creation
public extension FwiRequest {

    // MARK: Class's constructors
    public convenience init(url: NSURL, httpMethod method: FwiHttpMethod = .Get) {
        self.init(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        raw = nil
        form = nil
        upload = nil
        methodType = method

        switch method {
        case .Copy:
            self.HTTPMethod = "COPY"
            break

        case .Delete:
            self.HTTPMethod = "DELETE"
            break

        case .Head:
            self.HTTPMethod = "HEAD"
            break

        case .Link:
            self.HTTPMethod = "LINK"
            break

        case .Options:
            self.HTTPMethod = "OPTIONS"
            break

        case .Patch:
            self.HTTPMethod = "PATCH"
            break

        case .Post:
            self.HTTPMethod = "POST"
            break

        case .Purge:
            self.HTTPMethod = "PURGE"
            break

        case .Put:
            self.HTTPMethod = "PUT"
            break

        case .Unlink:
            self.HTTPMethod = "UNLINK"
            break


        default:
            self.HTTPMethod = "GET"
            break
        }
    }
}
