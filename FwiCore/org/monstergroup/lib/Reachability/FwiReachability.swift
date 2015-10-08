////  Project name: FwiCore
////  File name   : FwiReachability.swift
////
////  Author      : Phuc, Tran Huu
////  Created date: 11/23/14
////  Version     : 1.00
////  --------------------------------------------------------------
////  Copyright (c) 2014 Monster Group. All rights reserved.
////  --------------------------------------------------------------
////
////  Permission is hereby granted, free of charge, to any person obtaining  a  copy
////  of this software and associated documentation files (the "Software"), to  deal
////  in the Software without restriction, including without limitation  the  rights
////  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
////  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
////  furnished to do so, subject to the following conditions:
////
////  The above copyright notice and this permission notice shall be included in all
////  copies or substantial portions of the Software.
////
////  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
////  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
////  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
////  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
////  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
////  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
////  SOFTWARE.
////
////
////  Disclaimer
////  __________
////  Although reasonable care has been taken to  ensure  the  correctness  of  this
////  software, this software should never be used in any application without proper
////  testing. Monster Group  disclaim  all  liability  and  responsibility  to  any
////  person or entity with respect to any loss or damage caused, or alleged  to  be
////  caused, directly or indirectly, by the use of this software.
//
//import Foundation
//import SystemConfiguration
//
//
//public enum FwiReachabilityState : UInt8 {
//    case None = 0x00
//    case WiFi = 0x01
//    case WWAN = 0x02
//}
//
//public let Notification_ReachabilityStateChanged = "Notification_ReachabilityStateChanged"
//
//func FwiPrintFlags(flags: SCNetworkReachabilityFlags) {
//    var message = "Reachability Status: "
//    
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsIsWWAN)               != 0 ? "W" : "-"    // Can be reached via an EDGE, GPRS, or other "cell" connection.
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsReachable)            != 0 ? "R" : "-"    // Can be reached using the current network configuration.
//    message += " "
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsTransientConnection)  != 0 ? "t" : "-"    // Can be reached via a transient connection, such as PPP.
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsConnectionRequired)   != 0 ? "c" : "-"    // Can be reached using the current network configuration, but a connection must first be established, such as dialup.
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsConnectionOnTraffic)  != 0 ? "C" : "-"    // Can be reached using the current network configuration, but a connection must first be established. Any traffic directed to the specified name or address will initiate the connection.
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsInterventionRequired) != 0 ? "i" : "-"    // Can be reached using the current network configuration, but a connection must first be established. In addition, some forms will be required to establish this connection.
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsConnectionOnDemand)   != 0 ? "D" : "-"    // Can be reached using the current network configuration, but a connection must first be established. The connection will be established "On Demand".
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsIsLocalAddress)       != 0 ? "l" : "-"    // The specified nodename or address is one associated with a network interface on the current system.
//    message += flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsIsDirect)             != 0 ? "d" : "-"    // The specified nodename or address will be routed directly to one of the interfaces in the system.
//    
//    FwiLog("\(message)")
//}
//func callback(target: SCNetworkReachability!, flags: SCNetworkReachabilityFlags, info: UnsafeMutablePointer<Void>) {
//    FwiPrintFlags(flags)
//    NSNotificationCenter.defaultCenter().postNotificationName(Notification_ReachabilityStateChanged, object: nil)
//}
//
//public class FwiReachability : NSObject {
//   
//    // MARK: Class's constructors
//    override public init() {
//        super.init()
//        
//        reachability  = nil
//        returnWiFiStatus = false
//    }
//    convenience init(reachability: SCNetworkReachability) {
//        self.init()
//        self.reachability = reachability
//    }
//
//    
//    // MARK: Class's properties
//    public var connectionRequired: Bool {
//        get {
//            /* Condition validation */
//            if (reachability == nil) {
//                return false
//            }
//            
//            var flags: SCNetworkReachabilityFlags = 0
//            SCNetworkReachabilityGetFlags(reachability, &flags)
//            return (flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsConnectionRequired) != 0)
//        }
//    }
//    public var reachabilityState: FwiReachabilityState {
//        get {
//            /* Condition validation */
//            if (reachability == nil) {
//                return .None
//            }
//            
//            var flags: SCNetworkReachabilityFlags = 0
//            var status = FwiReachabilityState.None
//
//            if (SCNetworkReachabilityGetFlags(reachability, &flags) != 0) {
//                status = (returnWiFiStatus == true ? self.statusWiFiWithFlags(flags) : self.statusInternetWithFlags(flags))
//            }
//            return status
//        }
//    }
//    
//    var returnWiFiStatus: Bool?
//    var reachability: SCNetworkReachability?
//    
//    
//    // MARK: Class's public methods
//    public func start() {
//        /* Condition validation */
//        if (reachability == nil) {
//            return
//        }
//        
//        // Create UnsafeMutablePointer and initialise with callback
//        let p = UnsafeMutablePointer<(SCNetworkReachability!, SCNetworkReachabilityFlags, UnsafeMutablePointer<Void>) -> Void>.alloc(1)
//        p.initialize(callback)
//        
//        // convert UnsafeMutablePointer to COpaquePointer
//        let cp = COpaquePointer(p)
//        
//        // convert COppaquePointer to CFunctionPointer
//        let fp = CFunctionPointer<(SCNetworkReachability!, SCNetworkReachabilityFlags, UnsafeMutablePointer<Void>) -> Void>(cp)
//        
//        if SCNetworkReachabilitySetCallback(reachability, fp, nil) == 0 {
//            
//            println(SCError()) // SCError() is returning 0
//            return
//        }
//        
//        // Add to default runloop
//        SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)
//    }
//    public func stop() {
//    }
//    
//    
//    // MARK: Class's private methods
//    func statusWiFiWithFlags(flags: SCNetworkReachabilityFlags) -> FwiReachabilityState {
//        return .None
//    }
//    func statusInternetWithFlags(flags: SCNetworkReachabilityFlags) -> FwiReachabilityState {
//        return .None
//    }
//}
//
//
//// Creation
//public extension FwiReachability {
//
//    /** Check the reachability of a given IP address. */
//    class public func reachabilityWithAddress(address: sockaddr_in) -> FwiReachability? {
//        return nil
//    }
//    /** Check the reachability of a given host name. */
//    class public func reachabilityWithHostname(hostname: String) -> FwiReachability? {
//        var reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostname as NSString).UTF8String).takeRetainedValue()
//        return FwiReachability(reachability: reachability)
//    }
//    
//    /** Checks whether the default route is available. Should be used by applications that do not connect to any particular host. */
//    class public func reachabilityForInternet() -> FwiReachability? {
//        return nil
//    }
//    /** Checks whether a local WiFi connection is available. */
//    class public func reachabilityForWiFi() -> FwiReachability? {
//        return nil
//    }
//}