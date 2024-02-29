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
    let inputFavoriteButtonTapped = Observable<Int?>(nil)
    let outputCoinData = Observable<[CoinEntity]?>(nil)
    let outputFavorite = Observable<[Bool]?>(nil)
    let outputFavoriteIndex = Observable<Int?>(nil)
    let outputReloadView = Observable<Void?>(nil)
    let outputError = Observable<CCError?>(nil)
    
    init() { transform() }
    
    private func transform() {
        inputSearchText.bind { [weak self] id in
            guard let self else { return }
            callRequest(id: id)
        }
        
        inputFavoriteButtonTapped.bind { [weak self] index in
            guard let self,
                  let index,
                  let coinData = outputCoinData.currentValue
            else { return }
            favoriteToggle(coin: coinData[index])
            setFavorite(coinData)
            outputFavoriteIndex.onNext(index)
        }
        
        
    }
    
    private func callRequest(id: String?) {
        guard let id else { return }
        repository.fetch(router: .searchCoin(query: id)) { [weak self] coin in
            guard let self else { return }
            switch coin {
            case .success(let success):
                setFavorite(success)
                outputCoinData.onNext(success)
            case .failure(let failure):
                outputError.onNext(checkError(error: failure))
            }

        }
    }
    
    private func setFavorite(_ coin: [CoinEntity]) {
        let fav = favoriteRepository.fetch().map { $0.coinID }
        let isFavorite = coin.map {
            fav.contains($0.id) ? true : false
        }
        
        outputFavorite.onNext(isFavorite)
    }
    
    private func favoriteToggle(coin: CoinEntity) {
        let fav = favoriteRepository.fetch().map { $0.coinID }
        
        if fav.contains(coin.id) {
            favoriteRepository.delete(favoriteRepository.fetchItem(id: coin.id))
        } else {
            let item = UserFavorite(coinID: coin.id)
            favoriteRepository.create(item)
        }
    }
}
