//
//  TrendingViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class TrendingViewModel: ViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: TrendingCoordinator?
    let trendingRepository = TrendingRepository()
    let coinRepository = CoinRepository()
    let favoriteRepository = UserFavoriteRepository()
    let inputViewWillAppear = Observable<Void?>(nil)
    let inputPushDetail = Observable<String?>(nil)
    let outputFavoriteCoinData = Observable<[CoinEntity]>([])
    let outputTrendingCoin = Observable<[CoinEntity]?>(nil)
    let outputTrendingNFT = Observable<[NFTEntity]?>(nil)
    let outputUpdateComplete = Observable<Bool>(false)
    let outputError = Observable<CCError?>(nil)
    
    // MARK: - Lifecycles
    
    init(coordinator: TrendingCoordinator?) {
        self.coordinator = coordinator
        transform()
    }
    
    // MARK: - Helpers
    
    private func transform() {
        inputViewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            setAllUpdate()
        }
        
        inputPushDetail.bind { [weak self] id in
            guard let self else { return }
            print(#function)
            coordinator?.pushToDetail(coinID: id)
        }
    }
    
    private func setAllUpdate() {
        let group = DispatchGroup()
        group.enter()
        callRequest(group: group)
        group.enter()
        callFavRequest(group: group)
        
        group.notify(queue: .main) {
            self.outputUpdateComplete.onNext(true)
        }
    }
    
    private func callRequest(group: DispatchGroup) {
        trendingRepository.fetch(router: .trending) { [weak self] trending in
            guard let self else { return }
            defer { group.leave() }
            switch trending {
            case .success(let success):
                outputTrendingCoin.onNext(success.coins)
                outputTrendingNFT.onNext(success.nfts)
            case .failure(let failure):
                outputError.onNext(checkError(error: failure))
            }
        }
    }
    
    private func callFavRequest(group: DispatchGroup) {
        let ids = favoriteRepository.fetch().map { $0.coinID }
        coinRepository.fetch(router: .coin(ids: ids)) { [weak self] coin in
            guard let self,
                  !ids.isEmpty
            else { 
                group.leave()
                return
            }
            defer { group.leave() }
            switch coin {
            case .success(let success):
                outputFavoriteCoinData.onNext(success)
            case .failure(let failure):
                outputError.onNext(checkError(error: failure))
            }
        }
    }
}
