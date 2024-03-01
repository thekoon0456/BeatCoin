//
//  UserFavoriteRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import RealmSwift

final class UserFavoriteRepository: RealmRepository {

    private let realm = try! Realm()
    
    func printURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    // MARK: - Create
    
    func create(_ item: UserFavorite) {
        do {
            try realm.write {
                realm.add(item)
                print("DEBUG: realm Create")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Read
    
    func fetch() -> [UserFavorite] {
        let item = realm.objects(UserFavorite.self)
        return Array(item)
    }
    
    func fetchItem(id: String) -> UserFavorite? {
        let item = realm.objects(UserFavorite.self).where { $0.coinID == id }.first
        return item
    }
    
    // MARK: - Update
    
    func update(_ item: UserFavorite) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateAll(item: [UserFavorite]) {
        do {
            try realm.write {
                realm.deleteAll()
                realm.add(item)
                print("DEBUG: realmUpdate \(item)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Delete
    
    func delete(_ item: UserFavorite?) {
        guard let item else { return }
        do {
            try realm.write {
                realm.delete(item)
                print("DEBUG: realm Delete")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
