//  File name   : Codable+Extension.swift
//
//  Author      : Phuc, Tran Huu
//  Editor      : Dung Vu
//  Created date: 9/13/17
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

import Foundation

public extension Encodable {
    /// Convert a model to JSON.
    func encodeJSON(format f: JSONEncoder.OutputFormatting? = nil, dateDecoding dt: JSONEncoder.DateEncodingStrategy? = nil, dataDecoding d: JSONEncoder.DataEncodingStrategy = .base64) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = d
        encoder.dateEncodingStrategy = dt ?? .secondsSince1970

        // Output format
        if let format = f {
            encoder.outputFormatting = format
        }
        return try encoder.encode(self)
    }
}

public extension Decodable {
    /// Map JSON to model.
    static func decodeJSON(_ json: Data?, dateDecoding dt: JSONDecoder.DateDecodingStrategy? = nil, dataDecoding d: JSONDecoder.DataDecodingStrategy = .base64) throws -> Self {
        guard let json = json else {
            let error = NSError(domain: FwiCore.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Input data must not be nil."])
            throw error
        }

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = d
        decoder.dateDecodingStrategy = dt ?? .secondsSince1970

        return try decoder.decode(self, from: json)
    }
}
