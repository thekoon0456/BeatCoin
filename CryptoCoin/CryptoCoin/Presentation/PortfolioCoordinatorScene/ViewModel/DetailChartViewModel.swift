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
    private let favoriteRepository = UserRepository()
    private var coinID: String?
    let inputViewDidLoad = Observable<Void?>(nil)
    let inputCoinName = Observable<String?>(nil)
    let inputFavorite = Observable<String?>(nil)
    let outputCoinData = Observable<[CoinEntity]>([])
    let outputFavorite = Observable<Bool?>(nil)
    let outputError = Observable<CCError?>(nil)
    let outputToast = Observable<Toast?>(nil)
    
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
        guard let user = favoriteRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        
        if favoriteID.contains(id) {
            favoriteRepository.deleteFav(id)
            outputFavorite.onNext(false)
            outputToast.onNext(.deleteFavorite(coin: id))
            return
        }
        
        //추가
        guard favoriteID.count < 10 else {
            outputToast.onNext(.maxFavorite)
            return
        }
        
        favoriteRepository.createFav(id)
        outputFavorite.onNext(true)
        outputToast.onNext(.setFavorite(coin: id))
    }
    
    private func checkFavorite(id: String?) {
        guard let id else { return }
        guard let user = favoriteRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        
        if favoriteID.contains(id) {
            outputFavorite.onNext(true)
        } else {
            outputFavorite.onNext(false)
        }
    }
    
    func pop() {
        coordinator?.pop()
    }
}
