//
//  RealmManager.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 11/3/25.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    func fetch<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func save<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print("Error saving object: \(error)")
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting object: \(error)")
        }
    }
    
    func deleteAll<T: Object>(_ type: T.Type) {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error deleting all objects: \(error)")
        }
    }
}
