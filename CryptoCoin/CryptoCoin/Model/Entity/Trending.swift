//
//  TrendingEntity.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

/*
 id id
 이름 name
 아이콘
 약어
 현재가
 오르내림
*/
 
struct Trending: Decodable {
    let coins: [TrendingCoin]
    let nfts: [TrendingNFT]
}

struct TrendingCoin: Decodable {
    let id: String //"pyth-network"
    let name: String //"Pyth Network"
    let symbol: String //"PYTH"
    let score: Int //순위 (0부터)
    let thumb: String //썸네일 URL "https://assets.coingecko.com/coins/images/31924/thumb/pyth.png?1701245725"
    let data: [TrendingCoinData]?
}

struct TrendingCoinData: Decodable {
    let price: String //현재 가격 "$3.92"
    let price_change_percentage_24H: [String: Double] //코인 변동폭 -> "kwd": 41.94207220207385
}

struct TrendingNFT: Decodable {
    let id: String //"pyth-network"
    let name: String //"Pyth Network"
    let symbol: String //"PYTH"
    let floor_price_in_native_currency: Double //현재가격
    let floor_price_24h_percentage_change: Double //등락여부 소수점 두자리까지
    let data: TrendingNFTData
}

struct TrendingNFTData: Decodable {
    let floor_price: String //"2.38 ETH"
}
