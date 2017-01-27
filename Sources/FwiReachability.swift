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


/// Define reachability state.
public enum FwiReachabilityState {
    case none
    case wifi
    
    #if os(iOS)
    case wwan
    #endif
}

/// Define reachability notification.
public let reachabilityChanged = NSNotification.Name("com.fiision.lib.FwiCore.ReachabilityChanged")

/// Define callback.
fileprivate let callBack: SystemConfiguration.SCNetworkReachabilityCallBack = { (target, networkFlags, info) in
    /* Condition validation */
    guard let info = info else {
        return
    }
    
    /* Condition validation: validate previous flag */
    let reachability = Unmanaged<FwiReachability>.fromOpaque(info).takeUnretainedValue()
    guard reachability.currentFlags != networkFlags else {
        return
    }
    reachability.currentFlags = networkFlags
    
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
    reachability._rx_stateChanged()
    NotificationCenter.default.post(name: reachabilityChanged, object: reachability)
}


open class FwiReachability: NSObject {

    // MARK: Struct's constructors
    public init(withReachability r: SCNetworkReachability, shouldReturnWiFiState s: Bool = false) {
        target = r
        shouldReturnWiFiState = s
    }
    
    /// Create reachability for a given hostname.
    ///
    /// parameter hostname (required): string represents a hostname (e.g. www.apple.com)
    public convenience init?(withHostname h: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, h) else {
            return nil
        }
        self.init(withReachability: reachability)
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
    
    fileprivate var shouldReturnWiFiState: Bool
    fileprivate var target: SCNetworkReachability
    fileprivate var currentFlags = SCNetworkReachabilityFlags(rawValue: 0)
    fileprivate var backgroundQueue = DispatchQueue.global(qos: .background)
    
    // MARK: Class's public methods
    /// Start monitoring network.
    public func start() {
        let contextInfo = UnsafeMutableRawPointer(Unmanaged<FwiReachability>.passUnretained(self).toOpaque())
        var context = SCNetworkReachabilityContext(version: 0, info: contextInfo, retain: nil, release: nil, copyDescription: nil)
        
        // Define network callback
        if !SCNetworkReachabilitySetCallback(target, callBack, &context) {
            stop()
            return
        }
        
        // Binding to background queue
        if !SCNetworkReachabilitySetDispatchQueue(target, backgroundQueue) {
            stop()
            return
        }
        
        var networkFlags = SCNetworkReachabilityFlags(rawValue: 0)
        SCNetworkReachabilityGetFlags(target, &networkFlags)
        callBack(target, networkFlags, contextInfo)
    }
    
    /// Stop monitoring network.
    public func stop() {
        SCNetworkReachabilitySetCallback(target, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(target, nil)
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
        
        var status: FwiReachabilityState = networkFlags.contains(.connectionRequired) ? .none : .wifi
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
    
    // MARK: RX support
    /// Override point where reachability had changed its's state.
    open func _rx_stateChanged() {
    }
}


// Creation
public extension FwiReachability {

    /// Create reachability to monitor Internet.
    public static func forInternet() -> FwiReachability? {
        var address = sockaddr(sa_len: __uint8_t(0),
                               sa_family: sa_family_t(AF_INET),
                               sa_data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        
        // Create reachability
        address.sa_len = UInt8(MemoryLayout.size(ofValue: address))
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &address) else {
            return nil
        }
        return FwiReachability(withReachability: reachability)
    }
    
    /// Create reachability to monitor WiFi.
    public static func forWiFi() -> FwiReachability? {
        var input = IN_LINKLOCALNETNUM
        let saData = Data(bytes: &input, count: MemoryLayout.size(ofValue: IN_LINKLOCALNETNUM))
        
        // Layout address memory
        let v1 = Int8(bitPattern: saData[0])
        let v2 = Int8(bitPattern: saData[1])
        let v3 = Int8(bitPattern: saData[2])
        let v4 = Int8(bitPattern: saData[3])
        var address = sockaddr(sa_len: __uint8_t(0),
                               sa_family: sa_family_t(AF_INET),
                               sa_data: (v1, v2, v3, v4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        
        // Create reachability
        address.sa_len = UInt8(MemoryLayout.size(ofValue: address))
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &address) else {
            return nil
        }
        return FwiReachability(withReachability: reachability, shouldReturnWiFiState: true)
    }
}
