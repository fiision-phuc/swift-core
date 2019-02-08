//  File name   : FwiActivityIndicator.swift
//
//  Author      : Krunoslav Zaher
//  Created date: 10/18/15
//  --------------------------------------------------------------
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//  --------------------------------------------------------------
//
//  Disclaimer
//  __________
//  This code is not original. Fiision Studio only renamed the software to prevent
//  conflict base on Fiision Studio's project management structure.
//
//  If you are looking for original, please:
//  - seealso:
//    [The RxSwift Library Reference]
//    (https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Services/ActivityIndicator.swift)

import RxSwift
import RxCocoa

public class FwiActivityIndicator: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    public typealias E = Bool

    /// Class's constructors.
    public init() {
        _loading = _relay.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    // MARK: Class's public methods
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _loading
    }

    // MARK: Class's internal methods
    internal func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }

    // MARK: Class's private methods
    private func increment() {
        _lock.lock()
        _relay.accept(_relay.value + 1)
        _lock.unlock()
    }

    private func decrement() {
        _lock.lock()
        _relay.accept(_relay.value - 1)
        _lock.unlock()
    }

    /// Class's private properties.
    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
}


private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable

    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }

    func dispose() {
        _dispose.dispose()
    }

    func asObservable() -> Observable<E> {
        return _source
    }
}
