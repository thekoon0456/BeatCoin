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
    let inputMoveFav = Observable<Void?>(nil)
    let inputProfileImage = Observable<Data?>(nil)
    let inputDismiss = Observable<Void?>(nil)
    
    let outputProfileImageData = Observable<Data?>(nil)
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
            //유저 없으면 생성
            if userRepository.fetch() == nil {
                userRepository.create(User())
            }
            
            setAllUpdate()
            setImageData()
        }
        
        inputPushDetail.bind { [weak self] id in
            guard let self else { return }
            coordinator?.pushToDetail(coinID: id)
        }
        
        inputMoveFav.bind { [weak self] _ in
            guard let self else { return }
            coordinator?.moveToFav()
        }
        
        inputProfileImage.bind { [weak self] data in
            guard let self else { return }
            userRepository.updateProfileImage(data)
            outputProfileImageData.onNext(data)
        }
        
        inputDismiss.bind { [weak self] _ in
            guard let self else { return }
            coordinator?.dismiss()
        }
    }
    
    private func setAllUpdate() {
        let group = DispatchGroup()
        callRequest(group: group)
        callFavRequest(group: group)
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            outputUpdateComplete.onNext(true)
        }
    }
    
    private func callRequest(group: DispatchGroup) {
        group.enter()
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
        group.enter()
        coinRepository.fetch(router: .coin(ids: favoriteID)) { [weak self] coin in
            guard let self,
                  !favoriteID.isEmpty else { return }
            defer { group.leave() }
            switch coin {
            case .success(let success):
                outputFavoriteCoinData.onNext(success)
            case .failure(let failure):
                outputError.onNext(checkError(error: failure))
            }
        }
    }
    
    private func setImageData() {
        guard let data = userRepository.fetchImageData() else { return }
        outputProfileImageData.onNext(data)
    }
    
    func showAlert(error: CCError) {
        coordinator?.showAlert(message: error.description,
                               okButtonTitle: "되돌아가기",
                               primaryButtonTitle: "재시도하기") { [weak self] in
            guard let self else { return }
            inputViewWillAppear.onNext(())
        }
    }
}
