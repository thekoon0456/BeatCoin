//
//  FavoriteViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class FavoriteViewModel: ViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: FavoriteCoordinator?
    let repository = CoinRepository()
    let favoriteRepository = UserFavoriteRepository()
    let inputViewWillAppear = Observable<Void?>(nil)
    let inputPushDetail = Observable<String?>(nil)
    let inputUpdateFavorite = Observable<[CoinEntity]?>(nil)
    let outputCoinData = Observable<[CoinEntity]>([])
    let outputError = Observable<CCError?>(nil)
    
    init(coordinator: FavoriteCoordinator?) {
        self.coordinator = coordinator
        transform()
    }
    
    private func transform() {
        inputViewWillAppear.bind { [weak self] tap in
            guard let self else { return }
            let ids = favoriteRepository.fetch().map { $0.coinID }
            callRequest(ids: ids)
        }
        
        inputPushDetail.bind { [weak self] id in
            guard let self else { return }
            coordinator?.pushToDetail(coinID: id)
        }
        
        inputUpdateFavorite.bind { [weak self] coin in
            guard let self,
            let coin
            else { return }
            let fav = coin.map { UserFavorite(coinID: $0.id) }
            favoriteRepository.updateAll(item: fav)
            outputCoinData.onNext(coin)
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
