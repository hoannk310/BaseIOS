//
//  DetailViewModel.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//

import RxSwift
import RxCocoa

class DetailViewModel: BaseViewModelType{
    struct Input {
        let trigger: Observable<Void>
    }
    struct Output {
        let goBack: Driver<Void>
        let errorTracker: ErrorTracker
        let activityIndicator: ActivityIndicator
    }
    
    let errorTracker = ErrorTracker()
    let activityIndicator = ActivityIndicator()
    
    func transform(input: Input) -> Output {
        let trigger = input.trigger
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
        
        return Output(goBack: trigger.asDriverOnErrorJustComplete(),
                      errorTracker: errorTracker,
                      activityIndicator: activityIndicator)
    }
}
