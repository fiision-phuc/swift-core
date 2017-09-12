//  Project name: FwiCore
//  File name   : FwiCore.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/20/14
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


// MARK: Log Function
public func FwiLog(_ message: String = "", className: String = #file, methodName: String = #function, line: Int = #line) {
    #if DEBUG
        if let name = className.split("/").last, name.length() > 0 {
            print("\(NSDate()) \(name) > [\(methodName) \(line)]: \(message)")
        }
    #endif
}

// MARK: HTTP Network
public enum FwiHttpMethod: String {
    case copy = "COPY"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case link = "LINK"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case purge = "PURGE"
    case put = "PUT"
    case unlink = "UNLINK"
}

public func FwiNetworkStatusIsSuccces(_ networkStatus: FwiNetworkStatus) -> Bool {
    return FwiNetworkStatus.ok.rawValue ..< FwiNetworkStatus.multipleChoices.rawValue ~= networkStatus.rawValue ||
           FwiNetworkStatus.notModified.rawValue == networkStatus.rawValue
}



public struct FwiNetworkStatus: OptionSet, CustomDebugStringConvertible, CustomStringConvertible {
    public typealias RawValue = Int

    public let rawValue: RawValue
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

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

    // MARK: CustomDebugStringConvertible's members
    public var debugDescription: String {
        return description
    }

    // MARK: CustomStringConvertible's members
    public var description: String {
        switch self {

        case FwiNetworkStatus.ok: return "Ok."
        case FwiNetworkStatus.created: return "Created."
        case FwiNetworkStatus.accepted: return "Accepted."
        case FwiNetworkStatus.nonAuthoritativeInfo: return "Non authoritative info."
        case FwiNetworkStatus.noContent: return "No content."
        case FwiNetworkStatus.resetContent: return "Reset content."
        case FwiNetworkStatus.partialContent: return "Partial content."

        case FwiNetworkStatus.multipleChoices: return "Multiple choices."
        case FwiNetworkStatus.movedPermanently: return "Moved permanently."
        case FwiNetworkStatus.found: return "Found."
        case FwiNetworkStatus.seeOther: return "See other"
        case FwiNetworkStatus.notModified: return "Not modified."
        case FwiNetworkStatus.useProxy: return "Use proxy"
        case FwiNetworkStatus.temporaryRedirect: return "Temporary redirect."

        case FwiNetworkStatus.badRequest: return "Bad request."
        case FwiNetworkStatus.unauthorizedAccess: return "Unauthorized access."
        case FwiNetworkStatus.paymentRequired: return "Payment required."
        case FwiNetworkStatus.forbidden: return "Forbidden."
        case FwiNetworkStatus.notFound: return "Not found."
        case FwiNetworkStatus.methodNotAllowed: return "Method not allowed."
        case FwiNetworkStatus.notAcceptable: return "Not acceptable."
        case FwiNetworkStatus.proxyAuthenticationRequired: return "Proxy authentication required."
        case FwiNetworkStatus.requestTimeout: return "Request timeout."
        case FwiNetworkStatus.conflict: return "Conflict."
        case FwiNetworkStatus.gone: return "Gone."
        case FwiNetworkStatus.lengthRequired: return "Length required."
        case FwiNetworkStatus.preconditionFailed: return "Precondition failed."
        case FwiNetworkStatus.requestEntityTooLarge: return "Request entity too large."
        case FwiNetworkStatus.requestUriTooLarge: return "Request URI too large."
        case FwiNetworkStatus.unsupportedMediaType: return "Unsupported media type."
        case FwiNetworkStatus.requestedRangeNotSatisfiable: return "Requested range not satisfiable."
        case FwiNetworkStatus.expectationFailed: return "Expectation failed."
        case FwiNetworkStatus.teapot: return "Teapot."
        case FwiNetworkStatus.unprocessableEntity: return "Unprocessable entity."
        case FwiNetworkStatus.locked: return "Locked."
        case FwiNetworkStatus.failedDependency: return "Failed dependency."
        case FwiNetworkStatus.unorderedCollection: return "Unordered collection."
        case FwiNetworkStatus.upgradeRequired: return "Upgrade required."
        case FwiNetworkStatus.preconditionFailed: return "Precondition required."
        case FwiNetworkStatus.tooManyRequests: return "Too many requests."
        case FwiNetworkStatus.requestHeaderFieldsTooLarge: return "Request header fields too large."

        case FwiNetworkStatus.internalServerError: return "Internal server error."
        case FwiNetworkStatus.notImplemented: return "Not implemented."
        case FwiNetworkStatus.badGateway: return "Bad gateway."
        case FwiNetworkStatus.serviceUnavailable: return "Service unavailable."
        case FwiNetworkStatus.gatewayTimeout: return "Gateway timeout."
        case FwiNetworkStatus.httpVersionNotSupported: return "HTTP version not supported."
        case FwiNetworkStatus.variantAlsoNegotiates: return "Variant also negotiates."
        case FwiNetworkStatus.insufficientStorage: return "Insufficient storage."
        case FwiNetworkStatus.loopDetected: return "Loop detected."
        case FwiNetworkStatus.networkAuthenticationRequired: return "Network authentication required."
            
        default:
            return HTTPURLResponse.localizedString(forStatusCode: rawValue)
        }
    }
}
