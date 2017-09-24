//  Project name: FwiCore
//  File name   : FwiJSONDeserialization+RX.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/2/16
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

import Foundation
import FwiCore

#if !RX_NO_MODULE
    import RxCocoa
    import RxSwift
#endif


public extension FwiJSONDeserialization where Self: NSObject {
    
    /// Send request to download a list of models.
    ///
    /// - parameter request (required): request
    public static func loadList(withRequest request: URLRequest?) -> Observable<(HTTPURLResponse, [DeserializeModel])> {
        return FwiNetwork.instance.rx.loadJSONArray(withRequest: request)
            .map({
                let (list, err) = map(array: $1)
                if let list = list {
                    return ($0, list)
                } else {
                    if let err = err {
                        throw err
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey : "There are data conflicts when parsing data from: '\(request?.url?.absoluteString ?? "")'."]
                        let err = NSError(domain: "FwiJSONDeserialization", code: -1, userInfo: userInfo)
                        throw err
                    }
                }
            })
    }
    
    /// Send request to download a model.
    ///
    /// - parameter request (required): request
    public static func loadModel(withRequest request: URLRequest?) -> Observable<(HTTPURLResponse, DeserializeModel)> {
        return FwiNetwork.instance.rx.loadJSONDictionary(withRequest: request)
            .map({
                let (m, err) = map(dictionary: $1)
                if let m = m {
                    return ($0, m)
                } else {
                    if let err = err {
                        throw err
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey : "There are data conflicts when parsing data from: '\(request?.url?.absoluteString ?? "")'."]
                        let err = NSError(domain: "FwiJSONDeserialization", code: -1, userInfo: userInfo)
                        throw err
                    }
                }
            })
    }
}

