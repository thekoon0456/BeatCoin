//
//  TrendingRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class TrendingRepository: Repository {

    func fetch(router: APIRouter, completionHandler: @escaping ((Result<TrendingEntity, Error>) -> Void)) {
        APIService.shared.callRequest(router: router,
                                      type: TrendingDTO.self) { data in
            switch data {
            case .success(let success):
                completionHandler(.success(success.toEntity))
            case .failure(let failure):
                completionHandler(.failure(failure))
            }
        }
    }
}
