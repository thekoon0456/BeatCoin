//
//  TrendingEntity.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation
 
struct TrendingEntity: Entity { //api 요청 한번만 하기 위해 묶음
    let coins: [CoinEntity]
    let nfts: [NFTEntity]
}
