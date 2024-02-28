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
    let inputViewDidLoad = Observable<[String]?>(nil)
    let outputCoinData = Observable<[CoinEntity]>([])
    
    init() { transform() }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] ids in
            guard let self else { return }
            callRequest(ids: ids)
        }
    }
    
    private func callRequest(ids: [String]?) {
        guard let ids else { return }
        repository.fetch(router: .coin(ids: ids)) { [weak self] coin in
            guard let self else { return }
            outputCoinData.onNext(coin)
        }
    }
}
