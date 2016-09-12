//  Project name: FwiCore
//  File name   : URLRequest+FwiExtensionTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/26/16
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

import XCTest
@testable import FwiCore


class URLRequestFwiExtensionTest: XCTestCase {
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }

    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }


    // MARK: Test Cases
    func testInit() {
        guard let url = URL(string: "https://google.com") else {
            XCTFail("Could not initialize url.")
            return
        }

        var request = URLRequest(url: url, requestMethod: .get)
        generalValidation(request)
        
        request = URLRequest(url: url, requestMethod: .get, extraHeaders: ["tag-header":"value-header"])
        generalValidation(request)
        XCTAssertEqual(request.value(forHTTPHeaderField: "tag-header"), "value-header", "Expected 'value-header' but found '\(request.value(forHTTPHeaderField: "tag-header"))'.")
    }
    
    func testFwiRequestType() {
        guard let url = URL(string: "https://google.com") else {
            XCTFail("Could not initialize url.")
            return
        }
        
        generalValidation(FwiRequestType.Raw(url: url, requestMethod: .get, extraHeaders: nil, rawParam: nil).request)
        generalValidation(FwiRequestType.URLEncode(url: url, requestMethod: .get, extraHeaders: nil, queryParams: nil).request)
        generalValidation(FwiRequestType.Multipart(url: url, requestMethod: .get, extraHeaders: nil, queryParams: nil, fileParams: nil).request)
    }
    
    
    func testGenerateRawForm() {
        guard let url = URL(string: "https://google.com"), let data = "FwiCore".toData() else {
            XCTFail("Could not initialize.")
            return
        }
        
        var request = URLRequest(url: url, requestMethod: .get)
        request.generateRawForm(FwiDataParam(data: data))
        
        XCTAssertEqual(request.httpBody, data, "Expected 'FwiCore' but found '\(request.httpBody?.toString())'.")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "text/plain; charset=UTF-8", "Expected 'text/plain; charset=UTF-8' but found '\(request.value(forHTTPHeaderField: "Content-Type"))'.")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Length"), "\(data.count)", "Expected '\(data.count)' but found '\(request.value(forHTTPHeaderField: "Content-Length"))'.")
    }
    
    func testGenerateMultipartForm() {
        guard let url = URL(string: "https://google.com"), let data = "FwiCore".toData() else {
            XCTFail("Could not initialize.")
            return
        }
        
        // Generate data
        let boundary = "----------\(Date().timeIntervalSince1970)"
        let queryParams = ["key1":"value1","key2":"value2"]
        let fileParams = [FwiMultipartParam(name: "text", fileName: "text.txt", contentData: data, contentType: "text/plain; charset=UTF-8")]
        
        var request = URLRequest(url: url, requestMethod: .get)
        request.generateMultipartForm(queryParams: queryParams, fileParams: fileParams, boundaryForm: boundary)
        
        let expectedForm = "\r\n--\(boundary)\r\n" +
                           "Content-Disposition: form-data; name=\"text\"; filename=\"text.txt\"\r\n" +
                           "Content-Type: text/plain; charset=UTF-8\r\n\r\n" +
                           "FwiCore" +
                           "\r\n--\(boundary)\r\n" +
                           "Content-Disposition: form-data; name=\"key2\"\r\n\r\n" +
                           "value2" +
                           "\r\n--\(boundary)\r\n" +
                           "Content-Disposition: form-data; name=\"key1\"\r\n\r\n" +
                           "value1" +
                           "\r\n--\(boundary)\r\n"
        
        XCTAssertEqual(request.httpBody, expectedForm.toData(), "Form does not layout correctly.")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "multipart/form-data; boundary=\(boundary)", "Expected 'multipart/form-data; boundary=\(boundary)' but found '\(request.value(forHTTPHeaderField: "Content-Type"))'.")
        
        if let length = expectedForm.toData()?.count {
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Length"), "\(length)", "Expected '\(length)' but found '\(request.value(forHTTPHeaderField: "Content-Length"))'.")
        } else {
            XCTFail("Could not determine length.")
        }
    }
    
    func testGenerateURLEncodedForm() {
        guard let url = URL(string: "https://google.com") else {
            XCTFail("Could not initialize.")
            return
        }
        
        // Generate data
        let queryParams = ["key1":"value1","key2":"value2"]
        
        var request = URLRequest(url: url, requestMethod: .get)
        request.generateURLEncodedForm(queryParams: queryParams)
        
        let expectedForm = "key2=value2&key1=value1"
        XCTAssertEqual(request.httpBody, expectedForm.toData(), "Form does not layout correctly.")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded", "Expected 'application/x-www-form-urlencoded' but found '\(request.value(forHTTPHeaderField: "Content-Type"))'.")
        
        if let length = expectedForm.toData()?.count {
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Length"), "\(length)", "Expected '\(length)' but found '\(request.value(forHTTPHeaderField: "Content-Length"))'.")
        } else {
            XCTFail("Could not determine length.")
        }
    }
    
    
    // MARK: Class's private methods
    fileprivate func generalValidation(_ request: URLRequest) {
        XCTAssertEqual(request.httpMethod, "GET", "Expected 'GET' but found '\(method)'.")
        XCTAssertNotNil(request.value(forHTTPHeaderField: "User-Agent"), "Expected 'User-Agent' header but found nil.")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "*/*", "Expected '*/*' but found '\(request.value(forHTTPHeaderField: "Accept"))'.")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept-Charset"), "UTF-8", "Expected 'UTF-8' but found '\(request.value(forHTTPHeaderField: "Accept-Charset"))'.")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Connection"), "close", "Expected 'close' but found '\(request.value(forHTTPHeaderField: "Connection"))'.")
    }
}
