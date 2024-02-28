//
//  CoinEntity.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

struct CoinEntity {
    let id: String //코인 id
    let name: String //코인 이름
    let symbol: String //코인 통화 단위
    let image: String //코인 아이콘
    let currentPrice: Int? //현재가
    let high24h: Int? //고가
    let low24h: Int? //저가
    let ath: Int? //신고점
    let athDate: String? //신고점일자
    let atl: Int? //신저점
    let atl_date: String? //신저점
    let lastUpdated: String? //업데이트 시각
    let sparklineIn7D: [Double]? //-> price
    let score: Int?
    let price: String?
    let priceChangePercentage24H: [String: Double]?
}
