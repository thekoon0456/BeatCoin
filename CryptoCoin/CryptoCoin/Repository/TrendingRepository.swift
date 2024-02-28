//
//  TrendingRepository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class TrendingRepository: Repository {

    func fetch(router: Router, completionHandler: @escaping ((TrendingEntity) -> Void)) {
        APIService.shared.callRequest(router: router,
                                      type: TrendingDTO.self) { data in
            completionHandler(data.toEntity)
        }
    }
}
