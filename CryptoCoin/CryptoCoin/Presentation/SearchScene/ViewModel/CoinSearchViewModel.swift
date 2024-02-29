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
            print(coin)
            outputCoinData.onNext(coin)
        }
    }
    
}
