//
//  NewsRepositoryImpl.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 12/3/25.
//

import RxSwift

protocol AuthRepository {
    func register(param: RegisterRequestEntity) -> Single<UserEntity>
    func login(param: LoginRequestEntity) -> Single<UserEntity>
}
