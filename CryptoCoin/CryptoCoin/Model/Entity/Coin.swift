//
//  Coin.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation
//[Coin]

struct Coin: Decodable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let current_price: String
    let high_24h: String
    let ath: Double
    let ath_date: String
    let atl: Double
    let atl_date: String
    let last_updated: String
    let sparkline_in_7d: [CoinSparkline]
}

struct CoinSparkline: Decodable { //차트 그리기 데이터
    let price: [Double]
}

