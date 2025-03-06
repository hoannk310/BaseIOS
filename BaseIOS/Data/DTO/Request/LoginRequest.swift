//
//  LoginRequest.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/20/25.
//

struct LoginRequest: Codable {
    var email: String
    var password: String
    
    static func fromEntity(_ entity: LoginRequestEntity) -> Self {
        return LoginRequest(email: entity.email, password: entity.password)
    }
}
