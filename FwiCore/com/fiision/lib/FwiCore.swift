//  Project name: FwiCore
//  File name   : FwiCore.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/20/14
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

// Degree/Radians constant
public let FLT_EPSILON: Float = 1.19209e-07
public let Metric_Circle: Float = 6.28319 // (360 degree)
public let Metric_DegreeToRadian: Double = 0.0174532925199432957
public let Metric_RadianToDegree: Double = 57.295779513082320876

// MARK: Log Function
#if DEBUG
    public func FwiLog(message: String = "", className: String = #file, methodName: String = #function, line: Int = #line) {
        if let name = className.split("/").last where name.length() > 0 {
            print("\(NSDate()) \(name) > [\(methodName) \(line)]: \(message)")
        }
    }
#else
    public func FwiLog(className: String = #file, methodName: String = #function, line: Int = #line, message: String?) {
    }
#endif

// MARK: Metric Function
public func FwiConvertToDegree(radianValue radian: Double) -> Double {
    let degree = radian * Metric_RadianToDegree
    return degree
}
public func FwiConvertToRadian(degreeValue degree: Double) -> Double {
    let radian = degree * Metric_DegreeToRadian
    return radian
}

// MARK: Custom Operator
infix operator <- {}

func <- <T>(inout left: T, right: AnyObject?) {
    if let value = right as? T {
        left = value
    }
}
func <- <T>(inout left: T?, right: AnyObject?) {
    left = right as? T
}

func <- <T>(inout left: [T], right: [AnyObject]?) {
    if let arrValue = right {
        var temp = [T]()

        arrValue.forEach {
            if let value = $0 as? T {
                temp.append(value)
            }
        }

        if temp.count > 0 {
            left = temp
        }
    }
}
func <- <T>(inout left: [T]?, right: [AnyObject]?) {
    if let arrValue = right {
        var temp = [T]()

        arrValue.forEach {
            if let value = $0 as? T {
                temp.append(value)
            }
        }

        if temp.count > 0 {
            left = temp
        }
    }
}

// MARK: HTTP Network
public enum FwiHttpMethod: UInt8 {
    case Copy    = 0x00
    case Delete  = 0x01
    case Get     = 0x02
    case Head    = 0x03
    case Link    = 0x04
    case Options = 0x05
    case Patch   = 0x06
    case Post    = 0x07
    case Purge   = 0x08
    case Put     = 0x09
    case Unlink  = 0x0a
}

public func FwiNetworkStatusIsSuccces(networkStatus: NetworkStatus) -> Bool {
    return ((200 <= networkStatus.rawValue && networkStatus.rawValue <= 299) || networkStatus.rawValue == 304)
}

public struct NetworkStatus: OptionSetType, CustomDebugStringConvertible, CustomStringConvertible {
    public static let Unknown = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorUnknown.rawValue)
    public static let Cancelled = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCancelled.rawValue)
    public static let BadURL = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorBadURL.rawValue)
    public static let TimedOut = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorTimedOut.rawValue)
    public static let UnsupportedURL = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorUnsupportedURL.rawValue)
    public static let CannotFindHost = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotFindHost.rawValue)
    public static let CannotConnectToHost = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotConnectToHost.rawValue)
    public static let NetworkConnectionLost = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorNetworkConnectionLost.rawValue)
    public static let DNSLookupFailed = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorDNSLookupFailed.rawValue)
    public static let HTTPTooManyRedirects = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorHTTPTooManyRedirects.rawValue)
    public static let ResourceUnavailable = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorResourceUnavailable.rawValue)
    public static let NotConnectedToInternet = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue)
    public static let RedirectToNonExistentLocation = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorRedirectToNonExistentLocation.rawValue)
    public static let BadServerResponse = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorBadServerResponse.rawValue)
    public static let UserCancelledAuthentication = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorUserCancelledAuthentication.rawValue)
    public static let UserAuthenticationRequired = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorUserAuthenticationRequired.rawValue)
    public static let ZeroByteResource = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorZeroByteResource.rawValue)
    public static let CannotDecodeRawData = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotDecodeRawData.rawValue)
    public static let CannotDecodeContentData = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotDecodeContentData.rawValue)
    public static let CannotParseResponse = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotParseResponse.rawValue)
    public static let FileDoesNotExist = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorFileDoesNotExist.rawValue)
    public static let FileIsDirectory = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorFileIsDirectory.rawValue)
    public static let NoPermissionsToReadFile = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorNoPermissionsToReadFile.rawValue)
    public static let DataLengthExceedsMaximum = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorDataLengthExceedsMaximum.rawValue)
    // SSL errors
    public static let SecureConnectionFailed = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorSecureConnectionFailed.rawValue)
    public static let ServerCertificateHasBadDate = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorServerCertificateHasBadDate.rawValue)
    public static let ServerCertificateUntrusted = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorServerCertificateUntrusted.rawValue)
    public static let ServerCertificateHasUnknownRoot = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorServerCertificateHasUnknownRoot.rawValue)
    public static let ServerCertificateNotYetValid = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorServerCertificateNotYetValid.rawValue)
    public static let ClientCertificateRejected = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorClientCertificateRejected.rawValue)
    public static let ClientCertificateRequired = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorClientCertificateRequired.rawValue)
    public static let CannotLoadFromNetwork = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotLoadFromNetwork.rawValue)
    // Download and file I/O errors
    public static let CannotCreateFile = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotCreateFile.rawValue)
    public static let CannotOpenFile = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotOpenFile.rawValue)
    public static let CannotCloseFile = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotCloseFile.rawValue)
    public static let CannotWriteToFile = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotWriteToFile.rawValue)
    public static let CannotRemoveFile = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotRemoveFile.rawValue)
    public static let CannotMoveFile = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCannotMoveFile.rawValue)
    public static let DownloadDecodingFailedMidStream = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorDownloadDecodingFailedMidStream.rawValue)
    public static let DownloadDecodingFailedToComplete = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorDownloadDecodingFailedToComplete.rawValue)
    // ???
    public static let InternationalRoamingOff = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorInternationalRoamingOff.rawValue)
    public static let CallIsActive = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorCallIsActive.rawValue)
    public static let DataNotAllowed = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorDataNotAllowed.rawValue)
    public static let RequestBodyStreamExhausted = NetworkStatus(rawValue: CFNetworkErrors.CFURLErrorRequestBodyStreamExhausted.rawValue)
    // 4xx Client Error
    public static let BadRequest = NetworkStatus(rawValue: 400)
    public static let UnauthorizedAccess = NetworkStatus(rawValue: 401)
    public static let PaymentRequired = NetworkStatus(rawValue: 402)
    public static let Forbidden = NetworkStatus(rawValue: 403)
    public static let NotFound = NetworkStatus(rawValue: 404)
    public static let MethodNotAllowed = NetworkStatus(rawValue: 405)
    public static let NotAcceptable = NetworkStatus(rawValue: 406)
    public static let ProxyAuthenticationRequired = NetworkStatus(rawValue: 407)
    public static let RequestTimeout = NetworkStatus(rawValue: 408)
    public static let Conflict = NetworkStatus(rawValue: 409)
    public static let Gone = NetworkStatus(rawValue: 410)
    public static let LengthRequired = NetworkStatus(rawValue: 411)
    public static let PreconditionFailed = NetworkStatus(rawValue: 412)
    public static let RequestEntityTooLarge = NetworkStatus(rawValue: 413)
    public static let RequestUriTooLarge = NetworkStatus(rawValue: 414)
    public static let UnsupportedMediaType = NetworkStatus(rawValue: 415)
    public static let RequestedRangeNotSatisfiable = NetworkStatus(rawValue: 416)
    public static let ExpectationFailed = NetworkStatus(rawValue: 417)
    public static let Teapot = NetworkStatus(rawValue: 418)
    public static let UnprocessableEntity = NetworkStatus(rawValue: 422)
    public static let Locked = NetworkStatus(rawValue: 423)
    public static let FailedDependency = NetworkStatus(rawValue: 424)
    public static let UnorderedCollection = NetworkStatus(rawValue: 425)
    public static let UpgradeRequired = NetworkStatus(rawValue: 426)
    public static let PreconditionRequired = NetworkStatus(rawValue: 428)
    public static let TooManyRequests = NetworkStatus(rawValue: 429)
    public static let RequestHeaderFieldsTooLarge = NetworkStatus(rawValue: 431)
    // 5xx Server Error
    public static let InternalServerError = NetworkStatus(rawValue: 500)
    public static let NotImplemented = NetworkStatus(rawValue: 501)
    public static let BadGateway = NetworkStatus(rawValue: 502)
    public static let ServiceUnavailable = NetworkStatus(rawValue: 503)
    public static let GatewayTimeout = NetworkStatus(rawValue: 504)
    public static let HTTPVersionNotSupported = NetworkStatus(rawValue: 505)
    public static let VariantAlsoNegotiates = NetworkStatus(rawValue: 506)
    public static let InsufficientStorage = NetworkStatus(rawValue: 507)
    public static let LoopDetected = NetworkStatus(rawValue: 508)
    public static let NetworkAuthenticationRequired = NetworkStatus(rawValue: 511)
    
    
    public let rawValue: Int32
    private var statusDescription: String?
    public init(rawValue: Int32) {
        self.rawValue = rawValue
        
        switch rawValue {
        case CFNetworkErrors.CFURLErrorUnknown.rawValue:
            statusDescription = "Unknown."
            break
        case CFNetworkErrors.CFURLErrorCancelled.rawValue:
            statusDescription = "Cancelled."
            break
        case CFNetworkErrors.CFURLErrorBadURL.rawValue:
            statusDescription = "Bad URL."
            break
        case CFNetworkErrors.CFURLErrorTimedOut.rawValue:
            statusDescription = "Timed out."
            break
        case CFNetworkErrors.CFURLErrorUnsupportedURL.rawValue:
            statusDescription = "Unsupported URL."
            break
        case CFNetworkErrors.CFURLErrorCannotFindHost.rawValue:
            statusDescription = "Cannot find host."
            break
        case CFNetworkErrors.CFURLErrorCannotConnectToHost.rawValue:
            statusDescription = "Cannot connect to host."
            break
        case CFNetworkErrors.CFURLErrorNetworkConnectionLost.rawValue:
            statusDescription = "Network connection lost."
            break
        case CFNetworkErrors.CFURLErrorDNSLookupFailed.rawValue:
            statusDescription = "DNS lookup failed."
            break
        case CFNetworkErrors.CFURLErrorHTTPTooManyRedirects.rawValue:
            statusDescription = "HTTP too many redirects."
            break
        case CFNetworkErrors.CFURLErrorResourceUnavailable.rawValue:
            statusDescription = "Resource unavailable."
            break
        case CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue:
            statusDescription = "Not connected to Internet."
            break
        case CFNetworkErrors.CFURLErrorRedirectToNonExistentLocation.rawValue:
            statusDescription = "Redirect to non existent location."
            break
        case CFNetworkErrors.CFURLErrorBadServerResponse.rawValue:
            statusDescription = "Bad server response."
            break
        case CFNetworkErrors.CFURLErrorUserCancelledAuthentication.rawValue:
            statusDescription = "User cancelled authentication."
            break
        case CFNetworkErrors.CFURLErrorUserAuthenticationRequired.rawValue:
            statusDescription = "User authentication required."
            break
        case CFNetworkErrors.CFURLErrorZeroByteResource.rawValue:
            statusDescription = "Zero byte resource."
            break
        case CFNetworkErrors.CFURLErrorCannotDecodeRawData.rawValue:
            statusDescription = "Cannot decode raw data."
            break
        case CFNetworkErrors.CFURLErrorCannotDecodeContentData.rawValue:
            statusDescription = "Cannot decode content data."
            break
        case CFNetworkErrors.CFURLErrorCannotParseResponse.rawValue:
            statusDescription = "Cannot parse response."
            break
        case CFNetworkErrors.CFURLErrorFileDoesNotExist.rawValue:
            statusDescription = "File does not exist."
            break
        case CFNetworkErrors.CFURLErrorFileIsDirectory.rawValue:
            statusDescription = "File is directory."
            break
        case CFNetworkErrors.CFURLErrorNoPermissionsToReadFile.rawValue:
            statusDescription = "No permissions to read file."
            break
        case CFNetworkErrors.CFURLErrorDataLengthExceedsMaximum.rawValue:
            statusDescription = "Data length exceeds maximum."
            break
        case CFNetworkErrors.CFURLErrorSecureConnectionFailed.rawValue:
            statusDescription = "Secure connection failed."
            break
        case CFNetworkErrors.CFURLErrorServerCertificateHasBadDate.rawValue:
            statusDescription = "Server certificate has bad date."
            break
        case CFNetworkErrors.CFURLErrorServerCertificateUntrusted.rawValue:
            statusDescription = "Server certificate untrusted."
            break
        case CFNetworkErrors.CFURLErrorServerCertificateHasUnknownRoot.rawValue:
            statusDescription = "Server certificate has unknown root."
            break
        case CFNetworkErrors.CFURLErrorServerCertificateNotYetValid.rawValue:
            statusDescription = "Server certificate not yet valid."
            break
        case CFNetworkErrors.CFURLErrorClientCertificateRejected.rawValue:
            statusDescription = "Client certificate rejected."
            break
        case CFNetworkErrors.CFURLErrorClientCertificateRequired.rawValue:
            statusDescription = "Client certificate required."
            break
        case CFNetworkErrors.CFURLErrorCannotLoadFromNetwork.rawValue:
            statusDescription = "Cannot load from network."
            break
        case CFNetworkErrors.CFURLErrorCannotCreateFile.rawValue:
            statusDescription = "Cannot create file."
            break
        case CFNetworkErrors.CFURLErrorCannotOpenFile.rawValue:
            statusDescription = "Cannot open file."
            break
        case CFNetworkErrors.CFURLErrorCannotCloseFile.rawValue:
            statusDescription = "Cannot close file."
            break
        case CFNetworkErrors.CFURLErrorCannotWriteToFile.rawValue:
            statusDescription = "Cannot write to file."
            break
        case CFNetworkErrors.CFURLErrorCannotRemoveFile.rawValue:
            statusDescription = "Cannot remove file."
            break
        case CFNetworkErrors.CFURLErrorCannotMoveFile.rawValue:
            statusDescription = "Cannot move file."
            break
        case CFNetworkErrors.CFURLErrorDownloadDecodingFailedMidStream.rawValue:
            statusDescription = "Download decoding failed mid stream."
            break
        case CFNetworkErrors.CFURLErrorDownloadDecodingFailedToComplete.rawValue:
            statusDescription = "Download decoding failed to complete."
            break
        case CFNetworkErrors.CFURLErrorInternationalRoamingOff.rawValue:
            statusDescription = "International roaming off."
            break
        case CFNetworkErrors.CFURLErrorCallIsActive.rawValue:
            statusDescription = "Call is active."
            break
        case CFNetworkErrors.CFURLErrorDataNotAllowed.rawValue:
            statusDescription = "Data not allowed."
            break
        case CFNetworkErrors.CFURLErrorRequestBodyStreamExhausted.rawValue:
            statusDescription = "Request body stream exhausted."
            break
        case 400:
            statusDescription = "Bad request."
            break
        case 401:
            statusDescription = "Unauthorized access."
            break
        case 402:
            statusDescription = "Payment required."
            break
        case 403:
            statusDescription = "Forbidden."
            break
        case 404:
            statusDescription = "Not found."
            break
        case 405:
            statusDescription = "Method not allowed."
            break
        case 406:
            statusDescription = "Not acceptable."
            break
        case 407:
            statusDescription = "Proxy authentication required."
            break
        case 408:
            statusDescription = "Request timeout."
            break
        case 409:
            statusDescription = "Conflict."
            break
        case 410:
            statusDescription = "Gone."
            break
        case 411:
            statusDescription = "Length required."
            break
        case 412:
            statusDescription = "Precondition failed."
            break
        case 413:
            statusDescription = "Request entity too large."
            break
        case 414:
            statusDescription = "Request URI too large."
            break
        case 415:
            statusDescription = "Unsupported media type."
            break
        case 416:
            statusDescription = "Requested range not satisfiable."
            break
        case 417:
            statusDescription = "Expectation failed."
            break
        case 418:
            statusDescription = "Teapot."
            break
        case 422:
            statusDescription = "Unprocessable entity."
            break
        case 423:
            statusDescription = "Locked."
            break
        case 424:
            statusDescription = "Failed dependency."
            break
        case 425:
            statusDescription = "Unordered collection."
            break
        case 426:
            statusDescription = "Upgrade required."
            break
        case 428:
            statusDescription = "Precondition required."
            break
        case 429:
            statusDescription = "Too many requests."
            break
        case 431:
            statusDescription = "Request header fields too large."
            break
        case 500:
            statusDescription = "Internal server error."
            break
        case 501:
            statusDescription = "Not implemented."
            break
        case 502:
            statusDescription = "Bad gateway."
            break
        case 503:
            statusDescription = "Service unavailable."
            break
        case 504:
            statusDescription = "Gateway timeout."
            break
        case 505:
            statusDescription = "HTTP version not supported."
            break
        case 506:
            statusDescription = "Variant also negotiates."
            break
        case 507:
            statusDescription = "Insufficient storage."
            break
        case 508:
            statusDescription = "Loop detected."
            break
        case 511:
            statusDescription = "Network authentication required."
            break
        default:
            statusDescription = ""
        }
    }
    
    // MARK: CustomDebugStringConvertible's members
    public var debugDescription: String {
        return description
    }
    
    // MARK: CustomStringConvertible's members
    public var description: String {
        if let d = statusDescription {
            return "[\(rawValue)] \(d)"
        }
        return "\(rawValue)"
    }
}