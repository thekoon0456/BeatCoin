//
//  TrendingEntity.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation
 
struct TrendingEntity {
    let coins: [TrendingCoin]
    let nfts: [TrendingNFT]
}

struct TrendingCoin {
    let id: String //"pyth-network"
    let name: String //"Pyth Network"
    let symbol: String //"PYTH"
    let thumb: String //썸네일 URL "https://assets.coingecko.com/coins/images/31924/thumb/pyth.png?1701245725"
    let score: Int //순위 (0부터)
    let price: String //현재 가격 "$3.92"
    let priceChangePercentage24H: [String: Double] //코인 변동폭 -> "kwd": 41.94207220207385
}

struct TrendingNFT {
    let id: String //"pyth-network"
    let name: String //"Pyth Network"
    let symbol: String //"PYTH"
    let thumb: String //"https://assets.coingecko.com/nft_contracts/images/149/standard/wassies.png?1707287210"
    let floorPrice: String //최저가 data -> floor_price  "0.080 BTC"
    let floorPrice24hPercentageChange: Double //등락여부 소수점 두자리까지
}
