//
//  SearchRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class SearchRepository {
    
    func fetch(router: Router, completionHandler: @escaping (([SearchCoinEntity]) -> Void)) {
        APIService.shared.callRequest(api: router,
                                      type: SearchDTO.self) { data in
            let searchEntitys = data.coins.map {
                SearchCoinEntity(id: $0.id,
                                 name: $0.name,
                                 apiSymbol: $0.apiSymbol,
                                 symbol: $0.symbol,
                                 thumb: $0.thumb)
            }
            
            completionHandler(searchEntitys)
        }
    }
}
