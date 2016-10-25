//  Project name: FwiCore
//  File name   : FwiReachability.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/23/14
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

import Foundation
import SystemConfiguration


/// Define reachability notification.
public let reachabilityStateChanged = NSNotification.Name(rawValue: "ReachabilityStateChanged")

/// Define reachability state.
public enum FwiReachabilityState {
    case none
    case wifi
    case wwan
}


public struct FwiReachability {

    // MARK: Struct's constructors
    public init(reachability r: SCNetworkReachability, shouldReturnWiFiState s: Bool = false) {
        target = r
        shouldReturnWiFiState = s
    }

    // MARK: Class's properties
    /// Check if network connection is required or not?
    public var connectionRequired: Bool {
        var networkFlags = SCNetworkReachabilityFlags(rawValue: 0)
        
        if SCNetworkReachabilityGetFlags(target, &networkFlags) {
            return networkFlags.contains(.connectionRequired)
        }
        return false
    }
    
    /// Return network's state.
    public var reachabilityState: FwiReachabilityState {
        var networkFlags = SCNetworkReachabilityFlags(rawValue: 0)
        var status = FwiReachabilityState.none
        
        if SCNetworkReachabilityGetFlags(target, &networkFlags) {
            status = (shouldReturnWiFiState ? statusWiFi(withFlags: networkFlags) : statusInternet(withFlags: networkFlags))
        }
        return status
    }
    
    /// Should return wifi state or not.
    fileprivate var shouldReturnWiFiState: Bool
    
    /// Network reachability target.
    fileprivate var target: SCNetworkReachability
    
    /// Define closure to handle network event.
    fileprivate lazy var callBack: SystemConfiguration.SCNetworkReachabilityCallBack = {
        let callBack: SystemConfiguration.SCNetworkReachabilityCallBack = { (target, networkFlags, info) in
            #if os(iOS)
                let w  = networkFlags.contains(.isWWAN)           ? "W" : "-"   // Can be reached via an EDGE, GPRS, or other "cell" connection.
            #else
                let w = "-"
            #endif
            let r  = networkFlags.contains(.reachable)            ? "R" : "-"   // Can be reached using the current network configuration.
            
            let t  = networkFlags.contains(.transientConnection)  ? "t" : "-"   // Can be reached via a transient connection, such as PPP.
            let c1 = networkFlags.contains(.connectionRequired)   ? "c" : "-"   // Can be reached using the current network configuration, but a connection must first be established, such as dialup.
            let c2 = networkFlags.contains(.connectionOnTraffic)  ? "C" : "-"   // Can be reached using the current network configuration, but a connection must first be established. Any traffic directed to the specified name or address will initiate the connection.
            let i  = networkFlags.contains(.interventionRequired) ? "i" : "-"   // Can be reached using the current network configuration, but a connection must first be established. In addition, some forms will be required to establish this connection.
            let d1 = networkFlags.contains(.connectionOnDemand)   ? "D" : "-"   // Can be reached using the current network configuration, but a connection must first be established. The connection will be established "On Demand".
            let l  = networkFlags.contains(.isLocalAddress)       ? "l" : "-"   // The specified nodename or address is one associated with a network interface on the current system.
            let d2 = networkFlags.contains(.isDirect)             ? "d" : "-"   // The specified nodename or address will be routed directly to one of the interfaces in the system.
            print("Reachability Status: \(w)\(r) \(t)\(c1)\(c2)\(i)\(d1)\(l)\(d2)")
            
            // Post notification
            if let p = info?.bindMemory(to: FwiReachability.self, capacity: 1) {
                NotificationCenter.default.post(name: reachabilityStateChanged, object: nil)
            }
        }
        return callBack
    }()
    
    // MARK: Class's public methods
    /// Start monitoring network.
    public mutating func start() {
        var context = SCNetworkReachabilityContext(version: 0, info: &self, retain: nil, release: nil, copyDescription: nil)
        if !SCNetworkReachabilitySetCallback(target, callBack, &context) {
            return
        }
        SCNetworkReachabilityScheduleWithRunLoop(target, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    }
    
    /// Stop monitoring network.
    public func stop() {
        SCNetworkReachabilityUnscheduleFromRunLoop(target, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    }

    // MARK: Class's private methods
    /// Check Internet's state with network flags.
    ///
    /// parameter flags (required): Network's flags obtains from target
    fileprivate func statusInternet(withFlags networkFlags: SCNetworkReachabilityFlags) -> FwiReachabilityState {
        /* Condition validation */
        guard networkFlags.contains(.reachable) else {
            return .none
        }
        
        var status = networkFlags.contains(.connectionRequired) ? FwiReachabilityState.none : FwiReachabilityState.wifi
        #if os(iOS)
            if networkFlags.contains(.isWWAN) {
                status = .wwan
            }
        #endif
        return status
    }
    
    /// Check WiFi's state with network flags.
    ///
    /// parameter flags (required): Network's flags obtains from target
    fileprivate func statusWiFi(withFlags networkFlags: SCNetworkReachabilityFlags) -> FwiReachabilityState {
        let isReachable = networkFlags.contains(.reachable) && networkFlags.contains(.isDirect)
        return (isReachable ? .wifi : .none)
    }
}


// Creation
public extension FwiReachability {

    /// Create reachability to monitor Internet.
    public static func forInternet() -> FwiReachability? {
        var address = sockaddr(sa_len: __uint8_t(0),
                               sa_family: sa_family_t(0),
                               sa_data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        
        address.sa_len = UInt8(MemoryLayout.size(ofValue: address))
        address.sa_family = sa_family_t(AF_INET)
        
        // Create reachability
        guard let reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, &address) else {
            return nil
        }
        return FwiReachability(reachability: reachability)
    }
    
    /// Create reachability to monitor WiFi.
    public static func forWiFi() -> FwiReachability? {
        var address = sockaddr(sa_len: __uint8_t(0),
                               sa_family: sa_family_t(0),
                               sa_data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        
        address.sa_len = UInt8(MemoryLayout.size(ofValue: address))
        address.sa_family = sa_family_t(AF_INET)
        
        // Create reachability
        guard let reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, &address) else {
            return nil
        }
        return FwiReachability(reachability: reachability, shouldReturnWiFiState: true)
    }
    
    /// Create reachability for a given hostname.
    ///
    /// parameter hostname (required): string represents a hostname (e.g. www.apple.com)
    public init?(withHostname h: String) {
        let cs = h.utf8CString
        
        // Convert hostname to CString
        let hostname = UnsafeMutablePointer<Int8>.allocate(capacity: cs.count)
        for (idx, c) in cs.enumerated() {
            hostname[idx] = c
        }
        
        // Create reachability
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            return nil
        }
        self.init(reachability: reachability)
    }
    
    public static func reachabilityWithAddress(address: sockaddr_in) -> FwiReachability? {
        return nil
    }
}
