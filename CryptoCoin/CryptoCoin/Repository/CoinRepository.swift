//
//  CoinRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class CoinRepository: Repository {
    
    func fetch(router: Router, completionHandler: @escaping (([CoinEntity]) -> Void)) {
        APIService.shared.callRequest(api: router,
                                      type: [CoinDTO].self) { data in
            let coinEntitys = data.map {
                CoinEntity(id: $0.id,
                           name: $0.name,
                           symbol: $0.symbol,
                           image: $0.image,
                           currentPrice: $0.currentPrice,
                           high24h: $0.high24H,
                           low24h: $0.low24H,
                           ath: $0.ath,
                           athDate: $0.athDate,
                           atl: $0.atl,
                           atl_date: $0.atlDate,
                           lastUpdated: $0.lastUpdated,
                           sparklineIn7D: $0.sparklineIn7D?.price ?? [])
            }
            
            completionHandler(coinEntitys)
        }
    }
}
