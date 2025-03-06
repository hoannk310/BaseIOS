//
//  Observable+Ex.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/7/25.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func doOnNext(_ onNext: @escaping (Element) throws -> Void) -> Observable<Element> {
        self.do(onNext: onNext)
    }
    
    func doOnNextOnMainThread(_ onNext: @escaping (Element) throws -> Void) -> Observable<Element> {
        self.do(onNext: { value in
            DispatchQueue.main.async {
                try? onNext(value)
            }
        })
    }

    func doOnError(_ onError: @escaping (Swift.Error) throws -> Void) -> Observable<Element> {
        self.do(onError: onError)
    }
    
    func doOnErrorOnMainThread(_ onError: @escaping (Swift.Error) throws -> Void) -> Observable<Element> {
        self.do(onError: { value in
            DispatchQueue.main.async {
                try? onError(value)
            }
        })
    }

    func doOnCompleted(_ onCompleted: @escaping () throws -> Void) -> Observable<Element> {
        self.do(onCompleted: onCompleted)
    }

    func subscribeNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        self.subscribe(onNext: onNext)
    }

    func subscribeError(_ onError: @escaping (Swift.Error) -> Void) -> Disposable {
        self.subscribe(onError: onError)
    }

    func subscribeCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        self.subscribe(onCompleted: onCompleted)
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func mapToString() -> Observable<String> {
        return map { "\($0)" }
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    public func doOnNext(_ onNext: @escaping (Element) -> Void) -> Driver<Element> {
        self.do(onNext: onNext)
    }

    public func doOnCompleted(_ onCompleted: @escaping () -> Void) -> Driver<Element> {
        self.do(onCompleted: onCompleted)
    }

    public func driveNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        self.drive(onNext: onNext)
    }

    public func driveCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        self.drive(onCompleted: onCompleted)
    }
}

public extension SharedSequence {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> { return map { _ in () } }
}
