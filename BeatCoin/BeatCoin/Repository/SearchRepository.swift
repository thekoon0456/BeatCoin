//
//  SearchRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class SearchRepository: Repository {
    
    func fetch(router: APIRouter, completionHandler: @escaping ((Result<[CoinEntity], Error>) -> Void)) {
        APIService.shared.callRequest(router: router,
                                      type: SearchDTO.self) { data in
            switch data {
            case .success(let success):
                completionHandler(.success(success.coins.map { $0.toEntity }))
            case .failure(let failure):
                completionHandler(.failure(failure))
            }
        }
    }
}
