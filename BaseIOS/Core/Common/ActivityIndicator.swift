//
//  ActivityIndicator.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/7/25.
//

import RxCocoa
import RxSwift

class ActivityIndicator: SharedSequenceConvertibleType {
    
    typealias SharingStrategy = DriverSharingStrategy
    typealias Element = Bool
    
    private let lock = NSRecursiveLock()
    private let loadingCountSubject = BehaviorRelay<Int>(value: 0)
    private let loading: SharedSequence<SharingStrategy,Bool>
    
    init() {
        self.loading = loadingCountSubject.asDriver()
            .map{ $0 > 0 }
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) ->
    Observable<O.Element> {
        weak var weakSelf = self
        return source.asObservable()
            .do(onNext: { _ in  weakSelf?.decrement()},
                onError: { _ in weakSelf?.decrement()},
                onCompleted: weakSelf?.decrement,
                onSubscribe:  weakSelf?.increment)
    }
    
    private func increment() {
        lock.lock()
        loadingCountSubject.accept(loadingCountSubject.value + 1)
        lock.unlock()
    }
    
    private func decrement() {
        lock.lock()
        let newValue = max(loadingCountSubject.value - 1, 0)
        loadingCountSubject.accept(newValue)
        lock.unlock()
    }
    
    func asSharedSequence() -> RxCocoa.SharedSequence<RxCocoa.DriverSharingStrategy, Bool> {
        return loading
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
