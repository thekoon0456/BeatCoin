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
    let userRepository = UserRepository()
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
            
            if userRepository.fetch() == nil {
                userRepository.create(User())
            }
            
            setAllUpdate()
        }
        
        inputPushDetail.bind { [weak self] id in
            guard let self else { return }
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
        guard let user = userRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        
        coinRepository.fetch(router: .coin(ids: favoriteID)) { [weak self] coin in
            guard let self,
                  !favoriteID.isEmpty
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

extension TrendingViewModel {
    
    func dismiss() {
        coordinator?.dismiss()
    }
}
