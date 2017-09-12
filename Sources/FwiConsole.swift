//  Project name: FwiCore
//  File name   : FwiConsole.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/11/16
//  Version     : 1.1.0
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

import Foundation


public struct FwiConsole {

    /// Output error to console.
    ///
    /// @param
    /// - request {URLRequest} (an original request to server)
    /// - data {Data} (response's data)
    /// - error {Error} (response's error)
    /// - statusCode {FwiNetworkStatus} (network's status)
    public static func consoleError(withRequest request: URLRequest, data d: Data?, error e: Error?, statusCode s: FwiNetworkStatus) {
        guard let err = e as NSError?, let url = request.url, let host = url.host, let method = request.httpMethod else {
            return
        }
        
        let domain     = "Domain     : \(host)\n"
        let urlString  = "HTTP Url   : \(url)\n"
        let httpMethod = "HTTP Method: \(method)\n"
        let status     = "HTTP Status: \(s.rawValue) (\(err.localizedDescription))\n"
        let dataString = "\(d?.toString() ?? "")"
        
        FwiLog("\n\(domain)\(urlString)\(httpMethod)\(status)\(dataString)")
    }
    
    /// Generate network error.
    ///
    /// @param
    /// - request {URLRequest} (an original request to server)
    /// - statusCode {FwiNetworkStatus} (network's status)
    public static func generateError(withRequest request: URLRequest, statusCode s: FwiNetworkStatus) -> NSError {
        let userInfo = [NSURLErrorFailingURLErrorKey:request.url?.description ?? "",
                        NSURLErrorFailingURLStringErrorKey:request.url?.description ?? "",
                        NSLocalizedDescriptionKey:s.description]

        return NSError(domain: NSURLErrorDomain, code: s.rawValue, userInfo: userInfo)
    }
}
