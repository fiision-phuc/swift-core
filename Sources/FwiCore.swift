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


/// Degree/Radians constant
public let FLT_EPSILON: Float = 1.19209e-07
public let Metric_Circle: Float = 6.28319 // (360 degree)
public let Metric_DegreeToRadian: Double = 0.0174532925199432957
public let Metric_RadianToDegree: Double = 57.295779513082320876

// MARK: Log Function
public func FwiLog(_ message: String = "", className: String = #file, methodName: String = #function, line: Int = #line) {
    #if DEBUG
        if let name = className.split("/").last, name.length() > 0 {
            print("\(NSDate()) \(name) > [\(methodName) \(line)]: \(message)")
        }
    #endif
}

// MARK: Metric Function
public func FwiConvertToDegree(radianValue radian: Double) -> Double {
    let degree = radian * Metric_RadianToDegree
    return degree
}
public func FwiConvertToRadian(degreeValue degree: Double) -> Double {
    let radian = degree * Metric_DegreeToRadian
    return radian
}

// MARK: HTTP Network
public enum FwiHttpMethod {
    case copy
    case delete
    case get
    case head
    case link
    case options
    case patch
    case post
    case purge
    case put
    case unlink
}

public func FwiNetworkStatusIsSuccces(_ networkStatus: FwiNetworkStatus) -> Bool {
    return 200 ..< 300 ~= networkStatus.rawValue || 304 == networkStatus.rawValue
}



public struct FwiNetworkStatus: OptionSet, CustomDebugStringConvertible, CustomStringConvertible {
    public typealias RawValue = Int
    
    public static let unknown = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorUnknown.rawValue))
    public static let cancelled = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCancelled.rawValue))
    public static let badURL = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorBadURL.rawValue))
    public static let timedOut = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorTimedOut.rawValue))
    public static let unsupportedURL = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorUnsupportedURL.rawValue))
    public static let cannotFindHost = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotFindHost.rawValue))
    public static let cannotConnectToHost = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue))
    public static let networkConnectionLost = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue))
    public static let dnsLookupFailed = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorDNSLookupFailed.rawValue))
    public static let httpTooManyRedirects = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorHTTPTooManyRedirects.rawValue))
    public static let resourceUnavailable = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorResourceUnavailable.rawValue))
    public static let notConnectedToInternet = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue))
    public static let redirectToNonExistentLocation = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorRedirectToNonExistentLocation.rawValue))
    public static let badServerResponse = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorBadServerResponse.rawValue))
    public static let userCancelledAuthentication = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorUserCancelledAuthentication.rawValue))
    public static let userAuthenticationRequired = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorUserAuthenticationRequired.rawValue))
    public static let zeroByteResource = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorZeroByteResource.rawValue))
    public static let cannotDecodeRawData = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotDecodeRawData.rawValue))
    public static let cannotDecodeContentData = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotDecodeContentData.rawValue))
    public static let cannotParseResponse = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotParseResponse.rawValue))
    public static let fileDoesNotExist = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorFileDoesNotExist.rawValue))
    public static let fileIsDirectory = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorFileIsDirectory.rawValue))
    public static let noPermissionsToReadFile = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorNoPermissionsToReadFile.rawValue))
    public static let dataLengthExceedsMaximum = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorDataLengthExceedsMaximum.rawValue))
    // SSL errors
    public static let secureConnectionFailed = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorSecureConnectionFailed.rawValue))
    public static let serverCertificateHasBadDate = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorServerCertificateHasBadDate.rawValue))
    public static let serverCertificateUntrusted = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorServerCertificateUntrusted.rawValue))
    public static let serverCertificateHasUnknownRoot = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorServerCertificateHasUnknownRoot.rawValue))
    public static let serverCertificateNotYetValid = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorServerCertificateNotYetValid.rawValue))
    public static let clientCertificateRejected = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorClientCertificateRejected.rawValue))
    public static let clientCertificateRequired = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorClientCertificateRequired.rawValue))
    public static let cannotLoadFromNetwork = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotLoadFromNetwork.rawValue))
    // Download and file I/O errors
    public static let cannotCreateFile = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotCreateFile.rawValue))
    public static let cannotOpenFile = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotOpenFile.rawValue))
    public static let cannotCloseFile = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotCloseFile.rawValue))
    public static let cannotWriteToFile = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotWriteToFile.rawValue))
    public static let cannotRemoveFile = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotRemoveFile.rawValue))
    public static let cannotMoveFile = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCannotMoveFile.rawValue))
    public static let downloadDecodingFailedMidStream = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorDownloadDecodingFailedMidStream.rawValue))
    public static let downloadDecodingFailedToComplete = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorDownloadDecodingFailedToComplete.rawValue))
    // ???
    public static let internationalRoamingOff = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorInternationalRoamingOff.rawValue))
    public static let callIsActive = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorCallIsActive.rawValue))
    public static let dataNotAllowed = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorDataNotAllowed.rawValue))
    public static let requestBodyStreamExhausted = FwiNetworkStatus(rawValue: RawValue(CFNetworkErrors.cfurlErrorRequestBodyStreamExhausted.rawValue))
    
    // 2xx Status
    public static let ok = FwiNetworkStatus(rawValue: 200)
    public static let created = FwiNetworkStatus(rawValue: 201)
    public static let accepted = FwiNetworkStatus(rawValue: 202)
    public static let nonAuthoritativeInfo = FwiNetworkStatus(rawValue: 203)
    public static let noContent = FwiNetworkStatus(rawValue: 204)
    public static let resetContent = FwiNetworkStatus(rawValue: 205)
    public static let partialContent = FwiNetworkStatus(rawValue: 206)
    // 3xx Status
    public static let multipleChoices = FwiNetworkStatus(rawValue: 300)
    public static let movedPermanently = FwiNetworkStatus(rawValue: 301)
    public static let found = FwiNetworkStatus(rawValue: 302)
    public static let seeOther = FwiNetworkStatus(rawValue: 303)
    public static let notModified = FwiNetworkStatus(rawValue: 304)
    public static let useProxy = FwiNetworkStatus(rawValue: 305)
    public static let temporaryRedirect = FwiNetworkStatus(rawValue: 307)
    // 4xx Status (Client error)
    public static let badRequest = FwiNetworkStatus(rawValue: 400)
    public static let unauthorizedAccess = FwiNetworkStatus(rawValue: 401)
    public static let paymentRequired = FwiNetworkStatus(rawValue: 402)
    public static let forbidden = FwiNetworkStatus(rawValue: 403)
    public static let notFound = FwiNetworkStatus(rawValue: 404)
    public static let methodNotAllowed = FwiNetworkStatus(rawValue: 405)
    public static let notAcceptable = FwiNetworkStatus(rawValue: 406)
    public static let proxyAuthenticationRequired = FwiNetworkStatus(rawValue: 407)
    public static let requestTimeout = FwiNetworkStatus(rawValue: 408)
    public static let conflict = FwiNetworkStatus(rawValue: 409)
    public static let gone = FwiNetworkStatus(rawValue: 410)
    public static let lengthRequired = FwiNetworkStatus(rawValue: 411)
    public static let preconditionFailed = FwiNetworkStatus(rawValue: 412)
    public static let requestEntityTooLarge = FwiNetworkStatus(rawValue: 413)
    public static let requestUriTooLarge = FwiNetworkStatus(rawValue: 414)
    public static let unsupportedMediaType = FwiNetworkStatus(rawValue: 415)
    public static let requestedRangeNotSatisfiable = FwiNetworkStatus(rawValue: 416)
    public static let expectationFailed = FwiNetworkStatus(rawValue: 417)
    public static let teapot = FwiNetworkStatus(rawValue: 418)
    public static let unprocessableEntity = FwiNetworkStatus(rawValue: 422)
    public static let locked = FwiNetworkStatus(rawValue: 423)
    public static let failedDependency = FwiNetworkStatus(rawValue: 424)
    public static let unorderedCollection = FwiNetworkStatus(rawValue: 425)
    public static let upgradeRequired = FwiNetworkStatus(rawValue: 426)
    public static let preconditionRequired = FwiNetworkStatus(rawValue: 428)
    public static let tooManyRequests = FwiNetworkStatus(rawValue: 429)
    public static let requestHeaderFieldsTooLarge = FwiNetworkStatus(rawValue: 431)
    // 5xx Status (Server error)
    public static let internalServerError = FwiNetworkStatus(rawValue: 500)
    public static let notImplemented = FwiNetworkStatus(rawValue: 501)
    public static let badGateway = FwiNetworkStatus(rawValue: 502)
    public static let serviceUnavailable = FwiNetworkStatus(rawValue: 503)
    public static let gatewayTimeout = FwiNetworkStatus(rawValue: 504)
    public static let httpVersionNotSupported = FwiNetworkStatus(rawValue: 505)
    public static let variantAlsoNegotiates = FwiNetworkStatus(rawValue: 506)
    public static let insufficientStorage = FwiNetworkStatus(rawValue: 507)
    public static let loopDetected = FwiNetworkStatus(rawValue: 508)
    public static let networkAuthenticationRequired = FwiNetworkStatus(rawValue: 511)


    public let rawValue: RawValue
    public init(rawValue: RawValue) {
        self.rawValue = rawValue

            
//        case 400:
//            statusDescription = "Bad request."
//            break
//        case 401:
//            statusDescription = "Unauthorized access."
//            break
//        case 402:
//            statusDescription = "Payment required."
//            break
//        case 403:
//            statusDescription = "Forbidden."
//            break
//        case 404:
//            statusDescription = "Not found."
//            break
//        case 405:
//            statusDescription = "Method not allowed."
//            break
//        case 406:
//            statusDescription = "Not acceptable."
//            break
//        case 407:
//            statusDescription = "Proxy authentication required."
//            break
//        case 408:
//            statusDescription = "Request timeout."
//            break
//        case 409:
//            statusDescription = "Conflict."
//            break
//        case 410:
//            statusDescription = "Gone."
//            break
//        case 411:
//            statusDescription = "Length required."
//            break
//        case 412:
//            statusDescription = "Precondition failed."
//            break
//        case 413:
//            statusDescription = "Request entity too large."
//            break
//        case 414:
//            statusDescription = "Request URI too large."
//            break
//        case 415:
//            statusDescription = "Unsupported media type."
//            break
//        case 416:
//            statusDescription = "Requested range not satisfiable."
//            break
//        case 417:
//            statusDescription = "Expectation failed."
//            break
//        case 418:
//            statusDescription = "Teapot."
//            break
//        case 422:
//            statusDescription = "Unprocessable entity."
//            break
//        case 423:
//            statusDescription = "Locked."
//            break
//        case 424:
//            statusDescription = "Failed dependency."
//            break
//        case 425:
//            statusDescription = "Unordered collection."
//            break
//        case 426:
//            statusDescription = "Upgrade required."
//            break
//        case 428:
//            statusDescription = "Precondition required."
//            break
//        case 429:
//            statusDescription = "Too many requests."
//            break
//        case 431:
//            statusDescription = "Request header fields too large."
//            break
//        case 500:
//            statusDescription = "Internal server error."
//            break
//        case 501:
//            statusDescription = "Not implemented."
//            break
//        case 502:
//            statusDescription = "Bad gateway."
//            break
//        case 503:
//            statusDescription = "Service unavailable."
//            break
//        case 504:
//            statusDescription = "Gateway timeout."
//            break
//        case 505:
//            statusDescription = "HTTP version not supported."
//            break
//        case 506:
//            statusDescription = "Variant also negotiates."
//            break
//        case 507:
//            statusDescription = "Insufficient storage."
//            break
//        case 508:
//            statusDescription = "Loop detected."
//            break
//        case 511:
//            statusDescription = "Network authentication required."
//            break
//        default:
//            statusDescription = ""
//        }
    }

    // MARK: CustomDebugStringConvertible's members
    public var debugDescription: String {
        return description
    }

    // MARK: CustomStringConvertible's members
    public var description: String {
//        if let d = statusDescription {
//            return "[\(rawValue)] \(d)"
//        }
        return "\(rawValue)"
    }
}
