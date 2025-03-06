//
//  ViewModel.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//
import RxSwift
import RxCocoa

class ViewModel: BaseViewModelType{
    @Injected
    private var useCase: AuthUseCase
    
    let errorTracker = ErrorTracker()

    func transform(input: Input) -> Output {
        let registerOutput = input.registerTrigger
            .flatMapLatest {[weak self] param -> Single<UserEntity> in
                guard let self = self else { return Single.error(APIError.unknown) }
                return self.useCase.register(param: param)
            }.trackError(errorTracker)
        
        let loginOutput = input.loginTrigger
            .flatMapLatest {[weak self] param -> Single<UserEntity> in
                guard let self = self else { return Single.error(APIError.unknown) }
                return self.useCase.login(param: param)
            }.trackError(errorTracker)
        
        return Output(registerOutput: registerOutput.asDriverOnErrorJustComplete(),
                      loginOutput: loginOutput.asDriverOnErrorJustComplete(),
                      errorTracker: errorTracker)
    }
}

extension ViewModel {
    struct Input {
        let registerTrigger: Observable<RegisterRequestEntity>
        let loginTrigger: Observable<LoginRequestEntity>
    }
    struct Output {
        let registerOutput: Driver<UserEntity>
        let loginOutput: Driver<UserEntity>
        let errorTracker: ErrorTracker
    }
}
