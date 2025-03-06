//
//  NewsUseCase.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 12/3/25.
//

import RxSwift

protocol AuthUseCase {
    func login(param: LoginRequestEntity) -> Single<UserEntity>
    func register(param: RegisterRequestEntity) -> Single<UserEntity>
}

class AuthUseCaseImpl: AuthUseCase {
  
    @Injected
    private var authRepository: AuthRepository
    
    func login(param: LoginRequestEntity) -> Single<UserEntity> {
        authRepository.login(param: param)
    }
    
    func register(param: RegisterRequestEntity) -> Single<UserEntity> {
        authRepository.register(param: param)
    }
    
}
