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
    @Persisted var name: String //Bitcoin
    @Persisted var symbol: String //"BTC" //대문자로 변환
    @Persisted var image: String //이미지url
    @Persisted var isFavorite: Bool //저장 여부
}
