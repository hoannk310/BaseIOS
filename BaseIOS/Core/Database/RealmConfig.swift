//
//  RealmConfig.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 11/3/25.
//

import RealmSwift

final class RealmConfig {
    static let currentSchemaVersion: UInt64 = 1
    
    static func config() {
        let config = Realm.Configuration(
            fileURL: getFileURL(),
            schemaVersion: currentSchemaVersion,
            migrationBlock: RealmMigration.migrationBlock)
        Realm.Configuration.defaultConfiguration = config
    }
    
    private static func getFileURL() -> URL? {
        let fileName = AppConfig.shared.realmFileName
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent(fileName)
    }
}
