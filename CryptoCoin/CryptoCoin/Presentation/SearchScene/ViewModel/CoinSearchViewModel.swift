//
//  CoinSearchViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class CoinSearchViewModel: ViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: SearchCoordinator?
    let repository = SearchRepository()
    let favoriteRepository = UserRepository()
    let inputPushDetail = Observable<String?>(nil)
    let inputSearchText = Observable<String?>(nil)
    let inputFavoriteButtonTapped = Observable<Int?>(nil)
    let outputCoinData = Observable<[CoinEntity]?>(nil)
    let outputFavorite = Observable<[Bool]?>(nil)
    let outputFavoriteIndex = Observable<Int?>(nil)
    let outputError = Observable<CCError?>(nil)
    let outputToast = Observable<Toast?>(nil)
    
    init(coordinator: SearchCoordinator?) {
        self.coordinator = coordinator
        transform()
    }
    
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
        
        inputPushDetail.bind { [weak self] id in
            guard let self else { return }
            coordinator?.pushToDetail(coinID: id)
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
        guard let user = favoriteRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        let isFavorite = coin.map {
            favoriteID.contains($0.id) ? true : false
        }
        
        outputFavorite.onNext(isFavorite)
    }
    
    private func favoriteToggle(coin: CoinEntity) {
        guard let user = favoriteRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        //삭제
        if favoriteID.contains(coin.id) {
            favoriteRepository.deleteFav(coin.id)
            outputToast.onNext(.deleteFavorite(coin: coin.id))
            return
        }
        
        //추가
        guard favoriteID.count < 10 else {
            outputToast.onNext(.maxFavorite)
            return
        }
        
        favoriteRepository.createFav(coin.id)
        outputToast.onNext(.setFavorite(coin: coin.id))
    }
    
    func pop() {
        coordinator?.pop()
    }
}
