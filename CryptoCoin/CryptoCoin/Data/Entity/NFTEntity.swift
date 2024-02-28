//
//  NFTEntity.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/28/24.
//

import Foundation

struct NFTEntity: Entity {
    let id: String //"pyth-network"
    let name: String //"Pyth Network"
    let symbol: String //"PYTH"
    let thumb: String //"https://assets.coingecko.com/nft_contracts/images/149/standard/wassies.png?1707287210"
    let floorPrice: String //최저가 data -> floor_price  "0.080 BTC"
    let floorPrice24hPercentageChange: Double //등락여부 소수점 두자리까지
}
