//
//  UserFavorite.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import RealmSwift

final class UserFavorite: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var coinID: String //검색 쿼리 id
    
    convenience init(coinID: String) {
        self.init()
        self.coinID = coinID
    }
}
