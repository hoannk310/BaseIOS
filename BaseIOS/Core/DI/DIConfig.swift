//
//  DIConfig.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/10/25.
//

class DIConfig {
    static func register() {
        registerServices()
        registerRepositories()
        registerUseCases()
    }

    private static func registerServices() {
        let di = DIContainer.shared
        di.register(AuthServiceImpl(), for: AuthService.self)
    }
    
    private static func registerRepositories() {
        let di = DIContainer.shared
        di.register(AuthRepositoryImpl(), for: AuthRepository.self)
    }
    
    private static func registerUseCases() {
        let di = DIContainer.shared
        di.register(AuthUseCaseImpl(), for: AuthUseCase.self)
    }
}
