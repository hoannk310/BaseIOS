//
//  RegisterRequest.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/20/25.
//

struct RegisterRequest: Codable {
    var email: String
    var password: String
    var name: String
    var age: Int
    
    static func fromEntity(_ entity: RegisterRequestEntity) -> Self {
        return .init(
            email: entity.email,
            password: entity.password,
            name: entity.name,
            age: entity.age
        )
    }
}
