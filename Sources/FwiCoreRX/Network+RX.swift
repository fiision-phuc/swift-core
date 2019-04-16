//  File name   : FwiNetwork+RX.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 10/21/16
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

import Alamofire
import FwiCore
import RxSwift

public extension Network {
    /// Reactive wrapper for `download(resource:method:params:encoding:headers:completion:)` function.
    ///
    /// - seealso:
    /// [The FwiCore Library Reference]
    /// (https://github.com/phuc0302/swift-core/blob/master/Sources/Network.swift)
    static func downloadResource(_ r: URLConvertible,
                                        method m: HTTPMethod = .get,
                                        params p: [String: Any]? = nil,
                                        encoding e: ParameterEncoding = URLEncoding.default,
                                        headers h: [String: String]? = nil,
                                        destination d: URLConvertible? = nil) -> Observable<(HTTPURLResponse, URL)> {
        return Observable.create { observer in
            let t = Network.download(resource: r, method: m, params: p, encoding: e, headers: h, destination: d, completion: { url, err, res in
                /* Condition validation: validate network's status */
                guard let response = res, let location = url else {
                    observer.on(.error(err ?? NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue, userInfo: nil)))
                    return
                }
                observer.on(.next((response, location)))
                observer.on(.completed)
            })

            
            return Disposables.create(with: t.cancel)
        }
    }

    /// Reactive wrapper for `send(request:method:params:encoding:headers:completion:)` function.
    ///
    /// - seealso:
    /// [The FwiCore Library Reference]
    /// (https://github.com/phuc0302/swift-core/blob/master/Sources/Network.swift)
    static func sendRequest(_ r: URLConvertible,
                                   method m: HTTPMethod = .get,
                                   params p: [String: Any]? = nil,
                                   encoding e: ParameterEncoding = URLEncoding.default,
                                   headers h: [String: String]? = nil) -> Observable<(HTTPURLResponse, Data)> {
        return Observable.create { observer in
            let t = Network.send(request: r, method: m, params: p, encoding: e, headers: h, completion: { d, err, res in
                /* Condition validation: validate network's status */
                guard let response = res, let data = d else {
                    observer.on(.error(err ?? NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue, userInfo: nil)))
                    return
                }
                observer.on(.next((response, data)))
                observer.on(.completed)
            })

            
            return Disposables.create(with: t.cancel)
        }
    }
}

#if swift(>=5.0)
public struct Response<T: Decodable> {
    public let model: T
    public init(from data: Data?) throws {
        guard let data = data else {
            let context = DecodingError.Context.init(codingPath: [], debugDescription: "Missing data.")
            throw DecodingError.dataCorrupted(context)
        }

        let decoder = JSONDecoder()
        model = try decoder.decode(T.self, from: data)
    }
}


public extension Network {
    typealias R = Swift.Result
    
    static func download(_ r: URLConvertible,
                         method m: HTTPMethod = .get,
                         params p: [String: Any]? = nil,
                         encoding e: ParameterEncoding = URLEncoding.default,
                         headers h: [String: String]? = nil,
                         destination d: URLConvertible? = nil) -> Observable<R<URL, Error>>
    {
        return Observable.create { observer in
            let t = Network.download(resource: r, method: m, params: p, encoding: e, headers: h, destination: d, completion: { url, err, res in
                defer { observer.onCompleted() }
                if let err = err {
                    observer.onNext(.failure(err))
                    return
                }
                
                if let url = url {
                    observer.onNext(.success(url))
                } else {
                    let e = NSError(domain: NSURLErrorDomain, code: URLError.cannotCreateFile.rawValue, userInfo: nil)
                    observer.onNext(.failure(e))
                }
            })
            return Disposables.create(with: t.cancel)
        }
    }
    
    static func send<T: Decodable>(_ r: URLConvertible,
                                   decodeTo type: T.Type,
                                   method m: HTTPMethod = .get,
                                   params p: [String: Any]? = nil,
                                   encoding e: ParameterEncoding = URLEncoding.default,
                                   headers h: [String: String]? = nil) -> Observable<R<Response<T>, Error>>
    {
        return Observable.create { observer in
            let t = Network.send(request: r, method: m, params: p, encoding: e, headers: h, completion: { d, err, res in
                /* Condition validation: validate network's status */
                defer { observer.onCompleted() }
                if let err = err {
                    observer.onNext(.failure(err))
                    return
                }
                let result = R { try Response<T>(from: d) }
                observer.onNext(result)
            })
            return Disposables.create(with: t.cancel)
        }
    }
}
#endif
