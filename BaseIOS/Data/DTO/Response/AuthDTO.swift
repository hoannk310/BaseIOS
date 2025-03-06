//
//  AuthDTO.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/20/25.
//

struct AuthDTO: Codable {
    var accessToken: String
    var refreshToken: String
    var user: UserDTO
}
