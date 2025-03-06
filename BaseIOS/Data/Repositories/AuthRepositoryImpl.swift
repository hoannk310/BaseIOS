//
//  NewsRepositoryImpl.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 12/3/25.
//

import RxSwift

class AuthRepositoryImpl: AuthRepository {
    
    @Injected
    private var authService: AuthService
    
    func register(param: RegisterRequestEntity) -> Single<UserEntity> {
        return authService.register(param: RegisterRequest.fromEntity(param))
            .do(onSuccess: {user in
                TokenManager.shared.accessToken = user.accessToken
                TokenManager.shared.refreshToken = user.refreshToken
            })
            .map { $0.user.toEntity() }
    }
    
    func login(param: LoginRequestEntity) -> RxSwift.Single<UserEntity> {
        return authService.login(param: LoginRequest.fromEntity(param))
            .do(onSuccess: {user in
                TokenManager.shared.accessToken = user.accessToken
                TokenManager.shared.refreshToken = user.refreshToken
            })
            .map { $0.user.toEntity() }
        
    }
    
}
