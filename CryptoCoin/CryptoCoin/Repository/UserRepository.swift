//
//  UserFavoriteRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import RealmSwift

final class UserRepository: RealmRepository {

    private let realm = try! Realm()
    
    func printURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    // MARK: - Create
    
    func create(_ item: User) {
        do {
            try realm.write {
                realm.add(item)
                print("DEBUG: realm Create")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createFav(_ id: String?) {
        guard let id else { return }
        do {
            try realm.write {
                let user = realm.objects(User.self)
                user.first?.favoriteID.append(id)
                print("DEBUG: favoriteID create")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Read
    
    func fetch() -> User? {
        let user = realm.objects(User.self)
        return user.first
    }
    
    func fetchItem(id: String) -> String? {
        let user = realm.objects(User.self).first
        return user?.favoriteID.where { $0 == id }.first
    }
    
    func fetchImageData() -> Data? {
        guard let user = realm.objects(User.self).first,
              let data = loadImageToDocument(fileName: user.id.stringValue)?.pngData() else { return nil }
        return data
    }
    
    // MARK: - Update
    
    func update(_ item: User) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateProfileImage(_ data: Data?) {
        do {
            try realm.write {
                guard let user = realm.objects(User.self).first,
                      let data
                else { return }
                removeImageFromDocument(fileName: user.id.stringValue)
                saveImageToDocument(data, fileName: user.id.stringValue)
                user.profileImageURL = user.id.stringValue
                print("DEBUG: realmUpdateImage \(String(describing: user.profileImageURL))")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updatefav(item: [String]) {
        do {
            try realm.write {
                let user = realm.objects(User.self).first
                user?.favoriteID.removeAll()
                user?.favoriteID.append(objectsIn: item)
                print("DEBUG: realmUpdate \(item)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Delete
    
    func delete(_ item: User?) {
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
    
    func deleteFav(_ id: String?) {
        guard let id else { return }
        do {
            try realm.write {
                guard var fav = realm.objects(User.self).first?.favoriteID,
                    var idx = Array(fav).firstIndex(of: id) else { return }
                fav.remove(at: idx)
                realm.objects(User.self).first?.favoriteID = fav
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
