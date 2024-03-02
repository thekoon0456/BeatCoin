//
//  UserFavorite.swift
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
//    @Persisted var coinID: String //검색 쿼리 id
}
