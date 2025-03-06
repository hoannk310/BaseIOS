//
//  UserDTO.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/20/25.
//

struct UserDTO: Codable {
    var id: Int
    var name: String
    var email: String
    var age: Int
    
    func toEntity() -> UserEntity {
        return UserEntity(id: id, name: name, email: email, age: age)
    }
}
