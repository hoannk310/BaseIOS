//
//  TokenManager.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/20/25.
//

import RxSwift

class TokenManager {
    static let shared = TokenManager()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    var accessToken: String? {
        get {
            return KeychainHelper.shared.getFromKeychain(key: accessTokenKey)
        }
        set {
            if let newAccessToken = newValue {
               let _ = KeychainHelper.shared.saveToKeychain(key: accessTokenKey, value: newAccessToken)
            } else {
                let _ = KeychainHelper.shared.deleteFromKeychain(key: accessTokenKey)
            }
        }
    }
    
    var refreshToken: String? {
        get {
            return KeychainHelper.shared.getFromKeychain(key: refreshTokenKey)
        }
        set {
            if let newRefreshToken = newValue {
                let _ = KeychainHelper.shared.saveToKeychain(key: refreshTokenKey, value: newRefreshToken)
            } else {
                let _ = KeychainHelper.shared.deleteFromKeychain(key: refreshTokenKey)
            }
        }
    }
    
    func refreshAccessToken() -> Observable<Void> {
        guard let refreshToken = self.refreshToken else {
            return Observable.error(APIError.invalidRequest)
        }
                
        return NetworkManager.shared.request(APIRequest.refreshToken(RefreshTokenRequest(refreshToken: refreshToken)))
            .doOnNext({ [weak self] (response: RefreshTokenDTO) in
                self?.accessToken = response.accessToken
            })
            .mapToVoid()
    }
}
