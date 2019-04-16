//  File name   : SDKConfig.swift
//
//  Author      : Dung Vu
//  Created date: 3/25/19
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2019 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import Foundation
import SwiftProtobuf

// Use objc
@objcMembers
public final class SDKConfig: NSObject {
    fileprivate(set) var analytic: Analytic? {
        didSet { list = execution { analytic?.events.map(Int.init) }.orNil(default: []) }
    }
    static let `default` = SDKConfig()
    private var currentTask: URLSessionDataTask?
    
    struct Config {
        static let path: URL = "https://fiisionstudio.com/analytics"
    }
    private var session: URLSession?
    private override init() {
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    public static func initializeConfig() {
        self.default.load()
    }
    
    private func load() {
        var request = URLRequest(url: Config.path)
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        self.currentTask = self.session?.dataTask(with: request)
        currentTask?.resume()
    }
}

extension SDKConfig: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            print((error as NSError).localizedFailureReason.orNil(default: ""))
        }
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let trust = challenge.protectionSpace.serverTrust else {
            return completionHandler(.performDefaultHandling, nil)
        }
        let urlCredential = URLCredential(trust: trust)
        completionHandler(.useCredential, urlCredential)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            let new = try Analytic(serializedData: data)
            analytic = new
        } catch {
            print((error as NSError).localizedFailureReason.orNil(default: ""))
        }

    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print((error as NSError).localizedFailureReason.orNil(default: ""))
        }
    }
}


