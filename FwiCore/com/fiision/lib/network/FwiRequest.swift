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


public class FwiRequest : NSMutableURLRequest {
   
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

        var length: UInt = 0
        if let data = raw?.data {
            self.HTTPBody = data
            if let contentType = raw?.contentType {
                setValue(contentType, forHTTPHeaderField: "Content-Type")
            }

            length = UInt(data.length)
            setValue("\(length)", forHTTPHeaderField: "Content-Length")
        }
        else {
            switch methodType! {
            case .Delete:
                break

            case .Get:
                if let params = form, url = URL?.absoluteString {
                    var stringParams = [String](count:params.count, repeatedValue: "")
                    for (idx, param) in enumerate(params) {
                        stringParams[idx] = "\(param)"
                    }
                    var stringData = join("&", stringParams)
                    var finalURL = "\(url)?\(stringData)"
                    self.URL = NSURL(string: finalURL)
                }
                break

            case .Patch, .Post, .Put:
                if form != nil && upload == nil {
                    setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

                    // Generate body content
                    if let params = form {
                        var stringParams = [String](count:params.count, repeatedValue: "")
                        for (idx, param) in enumerate(params) {
                            stringParams[idx] = "\(param)"
                        }
                        var stringData = join("&", stringParams)

                        // Assign data length
                        if let data = stringData.toData() {
                            HTTPBody = data
                            length = UInt(data.length)
                        }
                    }
                    setValue("\(length)", forHTTPHeaderField: "Content-Length")
                }
                else {
                    var boundary = "----------\(NSDate().timeIntervalSince1970)"
                    var contentType = "multipart/form-data; boundary=\(boundary)"
                    setValue(contentType, forHTTPHeaderField: "Content-Type")

                    // Generate body content
                    var body = NSMutableData()

                    // Multi files
                    if let files = upload {
                        for file in files {
                            if let
                                contentData = file.contentData,
                                boundaryData = "\r\n--\(boundary)\r\n".toData(),
                                contentType = "Content-Type: \(file.contentType)\r\n\r\n".toData(),
                                contentDisposition = "Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.fileName)\"\r\n".toData()
                            {
                                body.appendData(boundaryData)
                                body.appendData(contentDisposition)
                                body.appendData(contentType)
                                body.appendData(contentData)
                            }
                        }
                    }

                    // Multi params
                    if let params = form {
                        for param in params {
                            if let
                                contentData = param.value?.toData(),
                                boundaryData = "\r\n--\(boundary)\r\n".toData(),
                                contentDisposition = "Content-Disposition: form-data; name=\"\(param.key)\"\r\n\r\n".toData()
                            {
                                body.appendData(boundaryData)
                                body.appendData(contentDisposition)
                                body.appendData(contentData)
                            }
                        }
                    }

                    // Finalize request
                    if let boundaryData = "\r\n--\(boundary)\r\n".toData() {
                        body.appendData(boundaryData)
                    }

                    // Prepare body
                    HTTPBody = body
                    length = UInt(body.length)
                    setValue("\(length)", forHTTPHeaderField: "Content-Length")
                }
                break

            default:
                break
            }
        }
        return 0
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
        self.initializeForm()
        raw = nil

        form?.removeAll(keepCapacity: false)
        self.addFormParam(param)
    }
    public func addFormParams(params: [FwiFormParam]?) {
        self.initializeForm()
        raw = nil

        if let paramsForm = params {
            for param in paramsForm {
                form?.append(param)
            }
        }
    }
    public func setFormParams(params: [FwiFormParam]?) {
        self.initializeForm()
        raw = nil

        form?.removeAll(keepCapacity: false)
        self.addFormParams(params)
    }

    /** Add multipart parameter. */
    public func addMultipartParam(param: FwiMultipartParam?) {
        self.initializeUpload()
        raw = nil

        if let paramsMultipart = param {
            upload?.append(paramsMultipart)
        }
    }
    public func setMultipartParam(param: FwiMultipartParam?) {
        self.initializeUpload()
        raw = nil

        upload?.removeAll(keepCapacity: false)
        self.addMultipartParam(param)
    }
    public func addMultipartParams(params: [FwiMultipartParam]?) {
        self.initializeUpload()
        raw = nil

        if let paramsMultipart = params {
            for param in paramsMultipart {
                upload?.append(param)
            }
        }
    }
    public func setMultipartParams(params: [FwiMultipartParam]?) {
        self.initializeUpload()
        raw = nil

        upload?.removeAll(keepCapacity: false)
        self.addMultipartParams(params)
    }

    /** Set custom data param. */
    public func setDataParam(param: FwiDataParam?) {
        /* Condition validation: Validate method type */
        if !(methodType == FwiHttpMethod.Post || methodType == FwiHttpMethod.Patch || methodType == FwiHttpMethod.Put) {
            return;
        }
        raw = param

        form = nil
        upload = nil
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
        var bundleInfo = NSBundle.mainBundle().infoDictionary
        var deviceInfo = UIDevice.currentDevice();
        var bundleExecutable: String! = nil
        var bundleIdentifier: String! = ""
        var bundleVersion: String! = ""

        var model = deviceInfo.model
        var systemVersion = deviceInfo.systemVersion

        // Extract bundle's info
        if let executable = bundleInfo?[kCFBundleExecutableKey] as? String {
            bundleExecutable = executable
        }
        if let identifier = bundleInfo?[kCFBundleIdentifierKey] as? String {
            bundleIdentifier = identifier
        }
        if let version = bundleInfo?[kCFBundleVersionKey] as? String {
            bundleVersion = version
        }

        var userAgent = "\(bundleExecutable != nil ? bundleExecutable : bundleIdentifier)/\(bundleVersion) (\(model); iOS \(systemVersion); Scale/\(UIScreen.mainScreen().scale))"
        setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
}


// Creation
public extension FwiRequest {

    // MARK: Class's constructors
    public convenience init(url: NSURL, httpMethod method: FwiHttpMethod) {
        self.init(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        raw    = nil
        form   = nil
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