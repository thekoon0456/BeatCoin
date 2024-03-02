//
//  PortfolioViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class DetailChartViewModel: ViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: DetailChartCoordinator?
    private let repository = CoinRepository()
    private let favoriteRepository = UserFavoriteRepository()
    private var coinID: String?
    let inputViewDidLoad = Observable<Void?>(nil)
    let inputCoinName = Observable<String?>(nil)
    let inputFavorite = Observable<String?>(nil)
    let outputCoinData = Observable<[CoinEntity]>([])
    let outputFavorite = Observable<Bool?>(nil)
    let outputError = Observable<CCError?>(nil)
    
    init(coordinator: DetailChartCoordinator?, coinID: String?) {
        self.coordinator = coordinator
        self.coinID = coinID
        transform()
    }

    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            callRequest(id: coinID)
            checkFavorite(id: coinID)
        }
        
        inputFavorite.bind { [weak self] id in
            guard let self,
                  let id else { return }
            setFavorite(id: id)
        }
    }
    
    private func callRequest(id: String?) {
        guard let id else { return }
        repository.fetch(router: .coin(ids: [id])) { [weak self] coin in
            guard let self else { return }
            switch coin {
            case .success(let success):
                outputCoinData.onNext(success)
            case .failure(let failure):
                outputError.onNext(checkError(error: failure))
            }
        }
    }
    
    private func setFavorite(id: String) {
        let favorite = favoriteRepository.fetch()
        let favoriteID = favorite.map { $0.coinID }
        
        if favoriteID.contains(id) {
            favoriteRepository.delete(favoriteRepository.fetchItem(id: id))
            outputFavorite.onNext(false)
            return
        }
        
        //추가
        guard favorite.count < 10 else {
            outputError.onNext(.maxFavorite)
            return
        }
        let item = UserFavorite(coinID: id)
        favoriteRepository.create(item)
        outputFavorite.onNext(true)
    }
    
    private func checkFavorite(id: String?) {
        guard let id else { return }
        let fav = favoriteRepository.fetch().map { $0.coinID }
        if fav.contains(id) {
            outputFavorite.onNext(true)
        } else {
            outputFavorite.onNext(false)
        }
    }
    
    func removeChildCoordinator() {
        coordinator?.removeChildCoordinator()
    }
}
