//
//  AppConfig.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 11/3/25.
//

import Foundation

enum AppEnvironment: String {
    case debug = "DEBUG"
    case staging = "STAGING"
    case release = "RELEASE"
}

final class AppConfig {
    static let shared = AppConfig()

    private init() {}

    private var config: [String: Any] {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("⚠️ File Info.plist not found!")
        }
        return dict
    }
    
    var baseURL: String {
        config["BASE_URL"] as? String ?? ""
    }

    var realmFileName: String {
        config["REALM_FILE_NAME"] as? String ?? "default.realm"
    }

    var environment: AppEnvironment {
        AppEnvironment(rawValue: config["APP_ENV"] as? String ?? "DEBUG") ?? .debug
    }
}
