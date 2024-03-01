//
//  Repository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import RealmSwift

protocol Repository {
    associatedtype T = Entity
    
    func fetch(router: APIRouter, completionHandler: @escaping ((T) -> Void))
}

protocol RealmRepository {
    associatedtype T: Object
    
    func create(_: T)
    func fetch() -> [T]
    func update(_: T)
    func delete(_: T?)
    func deleteAll()
}
