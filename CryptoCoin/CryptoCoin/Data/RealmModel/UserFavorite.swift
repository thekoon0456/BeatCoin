//
//  UserFavorite.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import RealmSwift

final class UserFavorite: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var coinID: String //검색 쿼리 id
}
