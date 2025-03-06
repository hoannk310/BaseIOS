//
//  RealmMigration.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 11/3/25.
//

import RealmSwift

final class RealmMigration {
    static let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
        let migrations: [Int: (Migration) -> Void] = [:]
        for version in migrations.keys.sorted() where oldSchemaVersion < version {
            migrations[version]?(migration)
        }
    }
    
    private static func migrate<T: Object>(
        _ migration: Migration,
        for type: T.Type,
        block: (MigrationObject?, MigrationObject?) -> Void
    ) {
        migration.enumerateObjects(ofType: T.className(), block)
    }
}
