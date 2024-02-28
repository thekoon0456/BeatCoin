//
//  CoinRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class CoinRepository: Repository {
    
    func fetch(router: Router, completionHandler: @escaping (([CoinEntity]) -> Void)) {
        APIService.shared.callRequest(router: router,
                                      type: [CoinDTO].self) { data in
            completionHandler(data.map { $0.toEntity } )
        }
    }
}
