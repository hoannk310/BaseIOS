import RxSwift
import RxCocoa

class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishRelay<Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: _subject.accept)
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asDriverOnErrorJustComplete()
    }
    
    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
