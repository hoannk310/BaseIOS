//
//  DIContainer.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/10/25.
//

protocol ServiceLocating {
    func resolve<Service>() -> Service
}

final class DIContainer: ServiceLocating {
    static let shared = DIContainer()
    
    private var services: [String: Any] = [:]
    
    private init() {}
    
    func register<Service>(_ service: Service, for type: Service.Type) {
        let key = String(describing: type)
        services[key] = service
    }
    
    func registerFactory<Service>(_ factory: @escaping () -> Service, for type: Service.Type) {
        let key = String(describing: type)
        services[key] = factory
    }
    
    func resolve<Service>() -> Service {
        let key = String(describing: Service.self)
        
        if let factory = services[key] as? () -> Service {
            return factory()
        }
        guard let service = services[key] as? Service else {
            fatalError("Dependency \(key) is not registered")
        }
        return service
    }
}
