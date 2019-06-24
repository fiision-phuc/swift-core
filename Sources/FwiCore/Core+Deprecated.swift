//  File name   : FwiCore+Deprecated.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 2/11/19
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

public extension FwiLocale {
    @available(*, deprecated, renamed: "localized(_:)", message: "Will be removed in next version.")
    static func localized(forString s: String?) -> String {
        return localized(s)
    }
}

public extension Data {
    @available(*, deprecated, renamed: "toString(_:)", message: "Will be removed in next version.")
    func toString(stringEncoding encoding: String.Encoding) -> String? {
        return toString(encoding)
    }

    @available(*, deprecated, renamed: "read(_:readingMode:)", message: "Will be removed in next version.")
    static func read(fromFile url: URL?, readingMode mode: Data.ReadingOptions) throws -> Data {
        return try read(url, readingMode: mode)
    }

    @available(*, deprecated, renamed: "write(_:writingMode:)", message: "Will be removed in next version.")
    func write(toFile url: URL?, options: Data.WritingOptions = []) throws {
        try write(url, writingMode: options)
    }
}

public extension FileManager {
    @available(*, deprecated, renamed: "moveDirectory(_:to:)", message: "Will be removed in next version.")
    func moveDirectory(from srcURL: URL?, to dstURL: URL?) throws {
        return try moveDirectory(srcURL, to: dstURL)
    }

    @available(*, deprecated, renamed: "removeDirectory(_:)", message: "Will be removed in next version.")
    func removeDirectory(atURL url: URL?) throws {
        return try removeDirectory(url)
    }

    @available(*, deprecated, renamed: "fileExists(_:)", message: "Will be removed in next version.")
    func fileExists(atURL url: URL?) -> Bool {
        return fileExists(url)
    }

    @available(*, deprecated, renamed: "moveFile(_:to:)", message: "Will be removed in next version.")
    func moveFile(from srcURL: URL?, to dstURL: URL?) throws {
        try moveFile(srcURL, to: dstURL)
    }

    @available(*, deprecated, renamed: "removeFile(_:)", message: "Will be removed in next version.")
    func removeFile(atURL url: URL?) throws {
        try removeFile(url)
    }
}

public extension FileManager {
    @available(*, deprecated, renamed: "createDirectory(_:intermediateDirectories:attributes:)", message: "Will be removed in next version.")
    func createDirectory(atURL url: URL?, withIntermediateDirectories intermediate: Bool, attributes: [FileAttributeKey: Any]?) throws {
        try createDirectory(url, intermediateDirectories: intermediate, attributes: attributes)
    }

    @available(*, deprecated, renamed: "directoryExists(_:)", message: "Will be removed in next version.")
    func directoryExists(atURL url: URL?) -> Bool {
        return directoryExists(url)
    }
}

public extension NSCoding {
    @available(*, deprecated, renamed: "unarchive(_:)", message: "Will be removed in next version.")
    static func unarchive(fromData d: Data) throws -> Self {
        return try unarchive(d)
    }

    @available(*, deprecated, renamed: "unarchive(_:)", message: "Will be removed in next version.")
    static func unarchive(fromFile url: URL?) throws -> Self {
        return try unarchive(url)
    }

    @available(*, deprecated, renamed: "unarchive(_:)", message: "Will be removed in next version.")
    static func unarchive(fromUserDefaults key: String) throws -> Self {
        return try unarchive(key)
    }

    @available(*, deprecated, renamed: "archive(_:)", message: "Will be removed in next version.")
    func archive(toFile url: URL?) throws {
        try archive(url)
    }

    @available(*, deprecated, renamed: "archive(_:)", message: "Will be removed in next version.")
    @discardableResult
    func archive(toUserDefaults key: String) -> Bool {
        return archive(key)
    }
}

public extension Swift.Optional {
    @available(*, deprecated, renamed: "orNil(_:)", message: "Will be removed in next version.")
    func orNil(default: @autoclosure () -> Wrapped) -> Wrapped {
        return orNil(`default`())
    }
}

public extension NSNumber {
    @available(*, deprecated, renamed: "currency(_:decimalSeparator:groupingSeparator:usingSymbol:placeSymbolInFront:)", message: "Will be removed in next version.")
    func currency(withISO3 iso3: String,
                  decimalSeparator decimal: String = ".",
                  groupingSeparator grouping: String = ",",
                  usingSymbol isSymbol: Bool = true,
                  placeSymbolFront isFront: Bool = true) -> String? {
        return currency(iso3, decimalSeparator: decimal, groupingSeparator: grouping, usingSymbol: isSymbol, placeSymbolInFront: isFront)
    }
}

public extension Encodable {
    @available(*, deprecated, renamed: "encodeJSON(_:dateEncoding:dataEncoding:)", message: "Will be removed in next version.")
    func encodeJSON(format f: JSONEncoder.OutputFormatting? = nil, dateDecoding dt: JSONEncoder.DateEncodingStrategy? = nil, dataDecoding d: JSONEncoder.DataEncodingStrategy = .base64) throws -> Data {
        return try encodeJSON(f, dateEncoding: dt, dataEncoding: d)
    }
}

public extension KeyedDecodingContainer {
    @available(*, deprecated, renamed: "decode(_:)", message: "Will be removed in next version.")
    func decode(key: KeyedDecodingContainer.Key) throws -> Bool {
        return try decode(key)
    }

    @available(*, deprecated, renamed: "decode(_:)", message: "Will be removed in next version.")
    func decode(key: KeyedDecodingContainer.Key) throws -> Float {
        return try decode(key)
    }

    @available(*, deprecated, renamed: "decode(_:)", message: "Will be removed in next version.")
    func decode(key: KeyedDecodingContainer.Key) throws -> Double {
        return try decode(key)
    }

    @available(*, deprecated, renamed: "decode(_:)", message: "Will be removed in next version.")
    func decode<T: Codable & SignedInteger>(key: KeyedDecodingContainer.Key) throws -> T {
        return try decode(key)
    }

    @available(*, deprecated, renamed: "decode(_:)", message: "Will be removed in next version.")
    func decode<T: Codable & UnsignedInteger>(key: KeyedDecodingContainer.Key) throws -> T {
        return try decode(key)
    }

    @available(*, deprecated, renamed: "decode(_:)", message: "Will be removed in next version.")
    func decode(key: KeyedDecodingContainer.Key) throws -> Data {
        return try decode(key)
    }

    @available(*, deprecated, renamed: "decode(_:)", message: "Will be removed in next version.")
    func decode(key: KeyedDecodingContainer.Key) throws -> Date {
        return try decode(key)
    }
}

public extension Localization {
    @available(*, deprecated, renamed: "localized(_:)", message: "Will be removed in next version.")
    func localized(forString s: String) -> String {
        return localized(s)
    }
}

public extension PlistProtocol where Self: Decodable {
    @available(*, deprecated, renamed: "load(_:fromBundle:)", message: "Will be removed in next version.")
    static func loadPlist(withPlistname n: String, fromBundle b: Bundle = Bundle.main) throws -> Self {
        return try load(n, fromBundle: b)
    }
}

#if canImport(Alamofire)
    import Alamofire

    public extension Network {
        @available(*, deprecated, renamed: "download(_:method:params:paramEncoding:headers:destinationURL:completion:)", message: "Will be removed in next version.")
        @discardableResult
        static func download(resource url: URLConvertible,
                             method m: HTTPMethod = .get,
                             params p: [String: Any]? = nil,
                             encoding e: ParameterEncoding = URLEncoding.default,
                             headers h: [String: String]? = nil,
                             destination d: URLConvertible? = nil,
                             completion c: @escaping DownloadCompletion) -> DownloadRequest {
            return download(url, method: m, params: p, paramEncoding: e, headers: h, destinationURL: d, completion: c)
        }

        @available(*, deprecated, renamed: "send(_:method:params:paramEncoding:headers:completion:)", message: "Will be removed in next version.")
        @discardableResult
        static func send(request r: URLConvertible,
                         method m: HTTPMethod = .get,
                         params p: [String: Any]? = nil,
                         encoding e: ParameterEncoding = URLEncoding.default,
                         headers h: [String: String]? = nil,
                         completion c: @escaping RequestCompletion) -> DataRequest {
            return send(r, method: m, params: p, paramEncoding: e, headers: h, completion: c)
        }
    }
#endif

#if canImport(UIKit) && os(iOS)
    import UIKit

    public extension UIView {
        /// Round corner of an UIView with specific radius.
        @available(*, deprecated, renamed: "cornerRadius", message: "Will be removed in next version.")
        func roundCorner(_ radius: CGFloat) {
            let bgLayer = self.layer
            bgLayer.masksToBounds = true
            bgLayer.cornerRadius = radius
        }
    }

    public extension Cell where Self: UICollectionViewCell {
        @available(*, deprecated, renamed: "loadNib(_:)", message: "Will be removed in next version.")
        static func loadNib(from bundle: Bundle?) -> UINib {
            return loadNib(bundle)
        }

        @available(*, deprecated, renamed: "dequeueCell(_:indexPath:)", message: "Will be removed in next version.")
        static func dequeueCell(collectionView c: UICollectionView, indexPath i: IndexPath) -> Self {
            return dequeueCell(c, indexPath: i)
        }
    }

    public extension Cell where Self: UITableViewCell {
        @available(*, deprecated, renamed: "loadNib(_:)", message: "Will be removed in next version.")
        static func loadNib(from bundle: Bundle?) -> UINib {
            return loadNib(bundle)
        }

        @available(*, deprecated, renamed: "dequeueCell(_:)", message: "Will be removed in next version.")
        static func dequeueCell(tableView t: UITableView) -> Self {
            return dequeueCell(t)
        }
    }

    public extension UIImage {
        @available(*, deprecated, renamed: "circularImage(_:)", message: "Will be removed in next version.")
        func circularImage(withSize size: CGFloat) -> UIImage? {
            return circularImage(size)
        }

        @available(*, deprecated, renamed: "circularImage(_:point:radius:)", message: "Will be removed in next version.")
        func circularImage(withSize size: CGFloat, point p: CGPoint, radius r: CGFloat) -> UIImage? {
            return circularImage(size, point: p, radius: r)
        }
    }
#endif
