//
//  AuthService.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 12/3/25.
//

import RxSwift

protocol AuthService {
    func register(param: RegisterRequest) -> Single<AuthDTO>
    func login(param: LoginRequest) -> Single<AuthDTO>
}

struct AuthServiceImpl: AuthService {
    func register(param: RegisterRequest) -> Single<AuthDTO> {
        return NetworkManager.shared.request(APIRequest.register(param)).asSingle()
    }
    
    func login(param: LoginRequest) -> Single<AuthDTO> {
        return NetworkManager.shared.request(APIRequest.login(param)).asSingle()
    }
}
