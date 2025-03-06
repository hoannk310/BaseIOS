//
//  APIRequest.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/5/25.
//

import Foundation

enum ApiMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum APIRequest {
    case register(RegisterRequest)
    case login(LoginRequest)
    case refreshToken(RefreshTokenRequest)
    
    private var baseURL: String { AppConfig.shared.baseURL }
    
    private var path: String {
        switch self {
        case .register:
            return "/auth/register"
        case .login:
            return "/auth/login"
        case .refreshToken:
            return "/auth/refresh-token"
        }
    }
    
    private var method: ApiMethodType {
        switch self {
        case .register, .login, .refreshToken:
            return .post
        }
    }
    
    private var parameters: Codable? {
        switch self {
        case .register, .login, .refreshToken:
            return nil
        }
    }
    
    private var body: Codable? {
        switch self {
        case .register(let body):
            return body
        case .login(let body):
            return body
        case .refreshToken(let body):
            return body
        }
    }
    
    private var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(TokenManager.shared.accessToken ?? "")"
        ]
    }
    
    private func encodeToDictionary<T: Encodable>(_ encodable: T) -> [String: String]? {
        guard let data = try? JSONEncoder().encode(encodable),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return dict.reduce(into: [String: String]()) { result, item in
            if let value = item.value as? CustomStringConvertible {
                result[item.key] = value.description
            }
        }
    }
    
    func asURLRequest() -> URLRequest? {
        guard let baseURL = URL(string: baseURL) else {
            return nil
        }
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.path += path
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        switch method {
        case .get:
            if let params = parameters,
               let paramsDict = encodeToDictionary(params) {
                urlComponents.queryItems = paramsDict.map { URLQueryItem(name: $0.key, value: $0.value) }
                urlRequest.url = urlComponents.url
            }
        case .post, .patch, .put:
            if let body = body {
                urlRequest.httpBody = try? JSONEncoder().encode(body)
            }
        case .delete:
            if let body = body {
                urlRequest.httpBody = try? JSONEncoder().encode(body)
            }
        }
        
        return urlRequest
    }
}
