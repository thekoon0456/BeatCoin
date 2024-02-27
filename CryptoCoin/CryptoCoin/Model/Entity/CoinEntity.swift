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
    let image: String //코인 아이콘 url
    let currentPrice: String //현재가
    let high24h: String //고가
    let low24h: String //저가
    let ath: Double //신고점
    let athDate: String //신고점일자
    let atl: Double //신저점
    let atl_date: String //신저점
    let lastUpdated: String //업데이트 시각
    let sparklineIn7d: [Double] //-> price
}
