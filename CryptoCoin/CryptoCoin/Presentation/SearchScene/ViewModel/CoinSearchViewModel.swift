//
//  CoinSearchViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class CoinSearchViewModel: ViewModel {
    
    // MARK: - Properties
    
    let repository = SearchRepository()
    let favoriteRepository = UserFavoriteRepository()
    let inputSearchText = Observable<String?>(nil)
    let outputCoinData = Observable<[CoinEntity]?>(nil)
    let outputFavorite = Observable<[Bool]?>(nil)
    
    init() { transform() }
    
    private func transform() {
        inputSearchText.bind { [weak self] id in
            guard let self else { return }
            callRequest(id: id)
        }
    }
    
    private func callRequest(id: String?) {
        guard let id else { return }
        repository.fetch(router: .searchCoin(query: id)) { [weak self] coin in
            guard let self else { return }
            outputCoinData.onNext(coin)
            checkFavorite(coin)
        }
    }
    
//    private func setFavorite(id: String) {
//        let fav = favoriteRepository.fetch().map { $0.coinID }
//        
//        if fav.contains(id) {
//            favoriteRepository.delete(favoriteRepository.fetchItem(id: id))
//            outputFavorite.onNext(false)
//        } else {
//            favoriteRepository.create(UserFavorite(coinID: id))
//            outputFavorite.onNext(true)
//        }
//    }
    
    private func checkFavorite(_ coin: [CoinEntity]) {
        let fav = favoriteRepository.fetch().map { $0.coinID }
        let isFavorite = coin.map { 
            fav.contains($0.id) ? true : false
        }
        outputFavorite.onNext(isFavorite)
    }
}
