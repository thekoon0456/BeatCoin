//
//  SearchRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class SearchRepository {
    
    func fetch(router: Router, completionHandler: @escaping ((Result<[CoinEntity], Error>) -> Void)) {
        APIService.shared.callRequest(router: router,
                                      type: SearchDTO.self) { data in
            switch data {
            case .success(let success):
                let entity = success.coins.map { $0.toEntity }
                completionHandler(.success(entity))
            case .failure(let failure):
                completionHandler(.failure(failure))
            }
        }
    }
}
