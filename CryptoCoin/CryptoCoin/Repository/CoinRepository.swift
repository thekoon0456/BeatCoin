//
//  CoinRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class CoinRepository: Repository {
    
    func fetch(router: Router, completionHandler: @escaping ((Result<[CoinEntity], Error>) -> Void)) {
        APIService.shared.callRequest(router: router,
                                      type: [CoinDTO].self) { data in
            switch data {
            case .success(let success):
                completionHandler(.success(success.map { $0.toEntity }))
            case .failure(let failure):
                completionHandler(.failure(failure))
            }
        }
    }
}
