//
//  FavoriteViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class FavoriteViewModel: ViewModel {
    
    // MARK: - Properties
    let repository = CoinRepository()
    let favoriteRepository = UserFavoriteRepository()
    let inputViewWillAppear = Observable<Void?>(nil)
    let outputCoinData = Observable<[CoinEntity]>([])
    let outputError = Observable<CCError?>(nil)
    
    init() { transform() }
    
    private func transform() {
        inputViewWillAppear.bind { [weak self] tap in
            guard let self else { return }
            let ids = favoriteRepository.fetch().map { $0.coinID }
            callRequest(ids: ids)
        }
    }
    
    private func callRequest(ids: [String]?) {
        guard let ids,
              !ids.isEmpty else { 
            outputCoinData.onNext([])
            return
        }
        
        repository.fetch(router: .coin(ids: ids)) { [weak self] coin in
            guard let self else { return }
            switch coin {
            case .success(let success):
                outputCoinData.onNext(success)
            case .failure(let failure):
                outputError.onNext(checkError(error: failure))
            }
        }
    }
}
