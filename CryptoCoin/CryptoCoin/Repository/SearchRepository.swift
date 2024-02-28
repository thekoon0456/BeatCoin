//
//  SearchRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class SearchRepository {
    
    func fetch(router: Router, completionHandler: @escaping (([CoinEntity]) -> Void)) {
        APIService.shared.callRequest(router: router,
                                      type: SearchDTO.self) { data in
            let entity = data.coins.map { $0.toEntity }
            completionHandler(entity)
        }
    }
}
