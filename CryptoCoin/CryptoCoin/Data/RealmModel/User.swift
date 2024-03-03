//
//  User.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import RealmSwift

final class User: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var profileImageURL: String?
    @Persisted var favoriteID: List<String>
    
    //처음 유저 만드는 시점에서 다른 데이터가 필요하지 않아 convenience init 구현 x
}
