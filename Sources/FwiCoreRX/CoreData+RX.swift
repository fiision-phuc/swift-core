//  File name   : CoreData+RX.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/13/16
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

import CoreData
import RxSwift
import FwiCore

public extension Reactive where Base: NSManagedObject, Base: FwiCoreData {
    /// Reactive wrapper for `allEntities(fromContext:predicate:sortDescriptor:groupBy:limit:)` function.
    ///
    /// - seealso:
    /// [The FwiCore Library Reference]
    /// (https://github.com/phuc0302/swift-core/blob/master/Sources/FwiCoreData.swift)
    static func allEntities(fromContext c: NSManagedObjectContext?, predicate p: NSPredicate? = nil, sortDescriptor s: [NSSortDescriptor]? = nil, groupBy g: [Any]? = nil, limit l: Int = 0) -> Observable<[Base]?> {
        return Observable.just(Base.allEntities(fromContext: c, predicate: p, sortDescriptor: s, groupBy: g, limit: l))
    }

    /// Reactive wrapper for `entity(fromContext:predicate:shouldCreate:)` function.
    ///
    /// - seealso:
    /// [The FwiCore Library Reference]
    /// (https://github.com/phuc0302/swift-core/blob/master/Sources/FwiCoreData.swift)
    static func entity(fromContext c: NSManagedObjectContext?, predicate p: NSPredicate? = nil, shouldCreate create: Bool = false) -> Observable<Base?> {
        return Observable.just(Base.entity(fromContext: c, predicate: p, shouldCreate: create))
    }

    /// Reactive wrapper for `count(fromContext:predicate:)` function.
    ///
    /// - seealso:
    /// [The FwiCore Library Reference]
    /// (https://github.com/phuc0302/swift-core/blob/master/Sources/FwiCoreData.swift)
    static func count(fromContext c: NSManagedObjectContext?, predicate p: NSPredicate? = nil) -> Observable<Int> {
        return Observable.just(Base.count(fromContext: c, predicate: p))
    }

    /// Reactive wrapper for `newEntity(withContext:)` function.
    ///
    /// - seealso:
    /// [The FwiCore Library Reference]
    /// (https://github.com/phuc0302/swift-core/blob/master/Sources/FwiCoreData.swift)
    static func newEntity(withContext c: NSManagedObjectContext?) -> Observable<Base?> {
        return Observable.just(Base.newEntity(withContext: c))
    }
}
