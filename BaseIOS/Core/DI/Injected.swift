//
//  Injected.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/10/25.
//

@propertyWrapper
struct Injected<Service> {
    private var service: Service
    
    init() {
        self.service = DIContainer.shared.resolve()
    }
    
    var wrappedValue: Service {
        get { service }
        mutating set {
            self.service = newValue
        }
    }
}
