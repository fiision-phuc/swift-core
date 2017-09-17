//  Project name: FwiCore
//  File name   : URLRequest+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/3/14
//  Version     : 2.0.0
//  --------------------------------------------------------------
//  Copyright © 2012, 2017 Fiision Studio.
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


// MARK: Struct's constructors
public extension URLRequest {

    public init(url: URL, requestMethod method: FwiHttpMethod, extraHeaders headers: [String:String]? = nil, cachePolicy cache: CachePolicy = .reloadIgnoringLocalCacheData) {
        self.init(url: url, cachePolicy: cache, timeoutInterval: 30.0)
        httpMethod = method.rawValue
        definePrefixHeaders()
        defineUserAgent()

        headers?.forEach({
            setValue($1, forHTTPHeaderField: $0)
        })
    }
    public init?(url: URL?, requestMethod method: FwiHttpMethod = .get, extraHeaders headers: [String:String]? = nil, cachePolicy cache: CachePolicy = .reloadIgnoringLocalCacheData) {
        guard let url = url else {
            return nil
        }
        self.init(url: url, requestMethod: method, extraHeaders: headers, cachePolicy: cache)
    }
}

// MARK: Struct's public methods
public extension URLRequest {

    /// Define basic authorization.
    public mutating func basicAuthentication(withUsername u: String?, andPassword p: String?) {
        guard let authorization = "\(u ?? ""):\(p ?? "")".encodeBase64String() else {
            return
        }
        setValue("Basic \(authorization)", forHTTPHeaderField: "Authorization")
    }

    /// Define oauth2 authorization.
    public mutating func oauthAuthentication(withToken t: String?) {
        setValue("Bearer \(t ?? "")", forHTTPHeaderField: "Authorization")
    }

    /// Manual define body data.
    public mutating func generateRawForm(_ rawParam: FwiDataParam?) {
        guard let p = rawParam else {
            return
        }
        let length = p.data.count

        setValue(p.contentType, forHTTPHeaderField: "Content-Type")
        setValue("\(length)", forHTTPHeaderField: "Content-Length")
        httpBody = p.data
    }

    /// Generate multipart/form-data.
    public mutating func generateMultipartForm(queryParams params: [String : String]?, fileParams files: [FwiMultipartParam]?, boundaryForm boundary: String = "----------\(Date().timeIntervalSince1970)") {
        /* Condition validation */
        if (params == nil && files == nil) || (params?.count == 0 && files?.count == 0) {
            return
        }
        var body = Data()

        // Multi files
        files?.forEach({
            if
                let boundaryData = "\r\n--\(boundary)\r\n".toData(),
                let contentType = "Content-Type: \($0.contentType)\r\n\r\n".toData(),
                let contentDisposition = "Content-Disposition: form-data; name=\"\($0.name)\"; filename=\"\($0.fileName)\"\r\n".toData()
            {
                body.append(boundaryData)
                body.append(contentDisposition)
                body.append(contentType)
                body.append($0.contentData)
            }
        })
        // Multi params
        params?.forEach({
            if
                let contentData = $0.value.toData(),
                let boundaryData = "\r\n--\(boundary)\r\n".toData(),
                let contentDisposition = "Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n".toData()
            {
                body.append(boundaryData)
                body.append(contentDisposition)
                body.append(contentData)
            }
        })
        // Finalize
        if let boundaryData = "\r\n--\(boundary)\r\n".toData() {
            body.append(boundaryData)
        }

        setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        httpBody = body
    }

    /// Generate x-www-form-urlencoded.
    public mutating func generateURLEncodedForm(queryParams params: [String : String]?) {
        guard let params = params, params.count > 0 else {
            return
        }

        // Generate form
        let query = params.map({ FwiFormParam(key: $0, value: $1).description }).joined(separator: "&")
        if let data = query.toData() {
            setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
            httpBody = data
        }
    }
}

// MARK: Struct's private methods
fileprivate extension URLRequest {

    /// Define prefix HTTP headers.
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

    /// Define user agent.
    fileprivate mutating func defineUserAgent() {
        #if os(iOS)
            let deviceInfo = UIDevice.current
            let bundleInfo = Bundle.main.infoDictionary
            let bundleVersion = (bundleInfo?[kCFBundleVersionKey as String] as? String) ?? ""
            let bundleIdentifier = (bundleInfo?[kCFBundleIdentifierKey as String] as? String) ?? ""

            let userAgent = "\(bundleIdentifier)/\(bundleVersion) (\(deviceInfo.model); iOS \(deviceInfo.systemVersion); Scale/\(UIScreen.main.scale))"
            setValue(userAgent, forHTTPHeaderField: "User-Agent")
        #endif
    }
}
