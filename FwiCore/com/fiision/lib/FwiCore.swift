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
    public func FwiLog(_ message: String = "", className: String = #file, methodName: String = #function, line: Int = #line) {
        if let name = className.split("/").last , name.length() > 0 {
            print("\(NSDate()) \(name) > [\(methodName) \(line)]: \(message)")
        }
    }
#else
    public func FwiLog(_ message: String = "", className: String = #file, methodName: String = #function, line: Int = #line) {
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
infix operator <-

func <- <T>(left: inout T, right: AnyObject?) {
    if let value = right as? T {
        left = value
    }
}
func <- <T>(left: inout T?, right: AnyObject?) {
    left = right as? T
}

func <- <T: NSObject>(left: inout T, right: AnyObject?) {
    let _ = FwiJSONMapper.mapObjectToModel(right, model: &left)
}

//func <- <T: NSObject>(left: inout T?, right: AnyObject?) {
//    let newObj = type(of: left)
//    
//    newObj.init()
//    let _ = FwiJSONMapper.mapObjectToModel(right, model: &left)
////    var newObject = T.init()
////    let error = FwiJSONMapper.mapObjectToModel(right, model: &newObject)
////    if error == nil {
////        left = newObject
////    }else {
////        left = nil
////    }
//}

func <- <T>(left: inout [T], right: [AnyObject]?) {
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
func <- <T>(left: inout [T]?, right: [AnyObject]?) {
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
    case copy    = 0x00
    case delete  = 0x01
    case get     = 0x02
    case head    = 0x03
    case link    = 0x04
    case options = 0x05
    case patch   = 0x06
    case post    = 0x07
    case purge   = 0x08
    case put     = 0x09
    case unlink  = 0x0a
}

public func FwiNetworkStatusIsSuccces(_ networkStatus: NetworkStatus) -> Bool {
    return ((200 <= networkStatus.rawValue && networkStatus.rawValue <= 299) || networkStatus.rawValue == 304)
}

public struct NetworkStatus: OptionSet, CustomDebugStringConvertible, CustomStringConvertible {
    public static let Unknown = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorUnknown.rawValue)
    public static let Cancelled = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCancelled.rawValue)
    public static let BadURL = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorBadURL.rawValue)
    public static let TimedOut = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorTimedOut.rawValue)
    public static let UnsupportedURL = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorUnsupportedURL.rawValue)
    public static let CannotFindHost = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotFindHost.rawValue)
    public static let CannotConnectToHost = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue)
    public static let NetworkConnectionLost = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue)
    public static let DNSLookupFailed = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorDNSLookupFailed.rawValue)
    public static let HTTPTooManyRedirects = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorHTTPTooManyRedirects.rawValue)
    public static let ResourceUnavailable = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorResourceUnavailable.rawValue)
    public static let NotConnectedToInternet = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue)
    public static let RedirectToNonExistentLocation = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorRedirectToNonExistentLocation.rawValue)
    public static let BadServerResponse = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorBadServerResponse.rawValue)
    public static let UserCancelledAuthentication = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorUserCancelledAuthentication.rawValue)
    public static let UserAuthenticationRequired = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorUserAuthenticationRequired.rawValue)
    public static let ZeroByteResource = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorZeroByteResource.rawValue)
    public static let CannotDecodeRawData = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotDecodeRawData.rawValue)
    public static let CannotDecodeContentData = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotDecodeContentData.rawValue)
    public static let CannotParseResponse = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotParseResponse.rawValue)
    public static let FileDoesNotExist = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorFileDoesNotExist.rawValue)
    public static let FileIsDirectory = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorFileIsDirectory.rawValue)
    public static let NoPermissionsToReadFile = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorNoPermissionsToReadFile.rawValue)
    public static let DataLengthExceedsMaximum = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorDataLengthExceedsMaximum.rawValue)
    // SSL errors
    public static let SecureConnectionFailed = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorSecureConnectionFailed.rawValue)
    public static let ServerCertificateHasBadDate = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorServerCertificateHasBadDate.rawValue)
    public static let ServerCertificateUntrusted = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorServerCertificateUntrusted.rawValue)
    public static let ServerCertificateHasUnknownRoot = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorServerCertificateHasUnknownRoot.rawValue)
    public static let ServerCertificateNotYetValid = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorServerCertificateNotYetValid.rawValue)
    public static let ClientCertificateRejected = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorClientCertificateRejected.rawValue)
    public static let ClientCertificateRequired = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorClientCertificateRequired.rawValue)
    public static let CannotLoadFromNetwork = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotLoadFromNetwork.rawValue)
    // Download and file I/O errors
    public static let CannotCreateFile = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotCreateFile.rawValue)
    public static let CannotOpenFile = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotOpenFile.rawValue)
    public static let CannotCloseFile = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotCloseFile.rawValue)
    public static let CannotWriteToFile = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotWriteToFile.rawValue)
    public static let CannotRemoveFile = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotRemoveFile.rawValue)
    public static let CannotMoveFile = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCannotMoveFile.rawValue)
    public static let DownloadDecodingFailedMidStream = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorDownloadDecodingFailedMidStream.rawValue)
    public static let DownloadDecodingFailedToComplete = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorDownloadDecodingFailedToComplete.rawValue)
    // ???
    public static let InternationalRoamingOff = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorInternationalRoamingOff.rawValue)
    public static let CallIsActive = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorCallIsActive.rawValue)
    public static let DataNotAllowed = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorDataNotAllowed.rawValue)
    public static let RequestBodyStreamExhausted = NetworkStatus(rawValue: CFNetworkErrors.cfurlErrorRequestBodyStreamExhausted.rawValue)
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
    fileprivate var statusDescription: String?
    public init(rawValue: Int32) {
        self.rawValue = rawValue

        switch rawValue {
        case CFNetworkErrors.cfurlErrorUnknown.rawValue:
            statusDescription = "Unknown."
            break
        case CFNetworkErrors.cfurlErrorCancelled.rawValue:
            statusDescription = "Cancelled."
            break
        case CFNetworkErrors.cfurlErrorBadURL.rawValue:
            statusDescription = "Bad URL."
            break
        case CFNetworkErrors.cfurlErrorTimedOut.rawValue:
            statusDescription = "Timed out."
            break
        case CFNetworkErrors.cfurlErrorUnsupportedURL.rawValue:
            statusDescription = "Unsupported URL."
            break
        case CFNetworkErrors.cfurlErrorCannotFindHost.rawValue:
            statusDescription = "Cannot find host."
            break
        case CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue:
            statusDescription = "Cannot connect to host."
            break
        case CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue:
            statusDescription = "Network connection lost."
            break
        case CFNetworkErrors.cfurlErrorDNSLookupFailed.rawValue:
            statusDescription = "DNS lookup failed."
            break
        case CFNetworkErrors.cfurlErrorHTTPTooManyRedirects.rawValue:
            statusDescription = "HTTP too many redirects."
            break
        case CFNetworkErrors.cfurlErrorResourceUnavailable.rawValue:
            statusDescription = "Resource unavailable."
            break
        case CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue:
            statusDescription = "Not connected to Internet."
            break
        case CFNetworkErrors.cfurlErrorRedirectToNonExistentLocation.rawValue:
            statusDescription = "Redirect to non existent location."
            break
        case CFNetworkErrors.cfurlErrorBadServerResponse.rawValue:
            statusDescription = "Bad server response."
            break
        case CFNetworkErrors.cfurlErrorUserCancelledAuthentication.rawValue:
            statusDescription = "User cancelled authentication."
            break
        case CFNetworkErrors.cfurlErrorUserAuthenticationRequired.rawValue:
            statusDescription = "User authentication required."
            break
        case CFNetworkErrors.cfurlErrorZeroByteResource.rawValue:
            statusDescription = "Zero byte resource."
            break
        case CFNetworkErrors.cfurlErrorCannotDecodeRawData.rawValue:
            statusDescription = "Cannot decode raw data."
            break
        case CFNetworkErrors.cfurlErrorCannotDecodeContentData.rawValue:
            statusDescription = "Cannot decode content data."
            break
        case CFNetworkErrors.cfurlErrorCannotParseResponse.rawValue:
            statusDescription = "Cannot parse response."
            break
        case CFNetworkErrors.cfurlErrorFileDoesNotExist.rawValue:
            statusDescription = "File does not exist."
            break
        case CFNetworkErrors.cfurlErrorFileIsDirectory.rawValue:
            statusDescription = "File is directory."
            break
        case CFNetworkErrors.cfurlErrorNoPermissionsToReadFile.rawValue:
            statusDescription = "No permissions to read file."
            break
        case CFNetworkErrors.cfurlErrorDataLengthExceedsMaximum.rawValue:
            statusDescription = "Data length exceeds maximum."
            break
        case CFNetworkErrors.cfurlErrorSecureConnectionFailed.rawValue:
            statusDescription = "Secure connection failed."
            break
        case CFNetworkErrors.cfurlErrorServerCertificateHasBadDate.rawValue:
            statusDescription = "Server certificate has bad date."
            break
        case CFNetworkErrors.cfurlErrorServerCertificateUntrusted.rawValue:
            statusDescription = "Server certificate untrusted."
            break
        case CFNetworkErrors.cfurlErrorServerCertificateHasUnknownRoot.rawValue:
            statusDescription = "Server certificate has unknown root."
            break
        case CFNetworkErrors.cfurlErrorServerCertificateNotYetValid.rawValue:
            statusDescription = "Server certificate not yet valid."
            break
        case CFNetworkErrors.cfurlErrorClientCertificateRejected.rawValue:
            statusDescription = "Client certificate rejected."
            break
        case CFNetworkErrors.cfurlErrorClientCertificateRequired.rawValue:
            statusDescription = "Client certificate required."
            break
        case CFNetworkErrors.cfurlErrorCannotLoadFromNetwork.rawValue:
            statusDescription = "Cannot load from network."
            break
        case CFNetworkErrors.cfurlErrorCannotCreateFile.rawValue:
            statusDescription = "Cannot create file."
            break
        case CFNetworkErrors.cfurlErrorCannotOpenFile.rawValue:
            statusDescription = "Cannot open file."
            break
        case CFNetworkErrors.cfurlErrorCannotCloseFile.rawValue:
            statusDescription = "Cannot close file."
            break
        case CFNetworkErrors.cfurlErrorCannotWriteToFile.rawValue:
            statusDescription = "Cannot write to file."
            break
        case CFNetworkErrors.cfurlErrorCannotRemoveFile.rawValue:
            statusDescription = "Cannot remove file."
            break
        case CFNetworkErrors.cfurlErrorCannotMoveFile.rawValue:
            statusDescription = "Cannot move file."
            break
        case CFNetworkErrors.cfurlErrorDownloadDecodingFailedMidStream.rawValue:
            statusDescription = "Download decoding failed mid stream."
            break
        case CFNetworkErrors.cfurlErrorDownloadDecodingFailedToComplete.rawValue:
            statusDescription = "Download decoding failed to complete."
            break
        case CFNetworkErrors.cfurlErrorInternationalRoamingOff.rawValue:
            statusDescription = "International roaming off."
            break
        case CFNetworkErrors.cfurlErrorCallIsActive.rawValue:
            statusDescription = "Call is active."
            break
        case CFNetworkErrors.cfurlErrorDataNotAllowed.rawValue:
            statusDescription = "Data not allowed."
            break
        case CFNetworkErrors.cfurlErrorRequestBodyStreamExhausted.rawValue:
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
