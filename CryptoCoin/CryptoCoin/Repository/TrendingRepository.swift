//
//  TrendingRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class TrendingRepository {
    
    func fetch(completionHandler: @escaping ((TrendingEntity) -> Void)) {
        APIService.shared.callRequest(api: .trending,
                                      type: TrendingDTO.self) { data in
            let coins = data.coins.map {
                TrendingCoin(id: $0.item.id,
                             name: $0.item.name,
                             symbol: $0.item.symbol,
                             thumb: $0.item.thumb,
                             score: $0.item.score,
                             price: $0.item.data.price,
                             priceChangePercentage24H: $0.item.data.priceChangePercentage24H.filter { $0.key == "krw"})
            }
            
            let nfts = data.nfts.map {
                TrendingNFT(id: $0.id,
                            name: $0.name,
                            symbol: $0.symbol,
                            thumb: $0.thumb,
                            floorPrice: $0.data.floorPrice,
                            floorPrice24hPercentageChange: $0.floorPrice24HPercentageChange)
            }
            
            let entity = TrendingEntity(coins: coins, nfts: nfts)
            completionHandler(entity)
        }
    }
}
