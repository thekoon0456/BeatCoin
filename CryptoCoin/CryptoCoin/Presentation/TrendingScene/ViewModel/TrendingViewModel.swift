//
//  TrendingViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class TrendingViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear = Observable<Void?>(nil)
        let pushDetail = Observable<String?>(nil)
        let moveToFavoriteTab = Observable<Void?>(nil)
        let profileImage = Observable<Data?>(nil)
        let dismiss = Observable<Void?>(nil)
    }
    
    struct Output {
        let profileImageData = Observable<Data?>(nil)
        let favoriteData = Observable<[CoinEntity]>([])
        let trendingCoinData = Observable<[CoinEntity]?>(nil)
        let trendingNFTData = Observable<[NFTEntity]?>(nil)
        let updateDone = Observable<Bool>(false)
        let error = Observable<CCError?>(nil)
    }
    
    // MARK: - Properties
    
    weak var coordinator: TrendingCoordinator?
    private let trendingRepository = TrendingRepository()
    private let coinRepository = CoinRepository()
    private let userRepository = UserRepository()
    let input = Input()
    let output = Output()
    
    // MARK: - Lifecycles
    
    init(coordinator: TrendingCoordinator?) {
        self.coordinator = coordinator
        transform()
    }
    
    // MARK: - Helpers
    
    private func transform() {
        input.viewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            //유저 없으면 생성
            if userRepository.fetch() == nil {
                userRepository.create(User())
            }
            
            setAllUpdate()
            setImageData()
        }
        
        input.pushDetail.bind { [weak self] id in
            guard let self else { return }
            coordinator?.pushToDetail(coinID: id)
        }
        
        input.moveToFavoriteTab.bind { [weak self] _ in
            guard let self else { return }
            coordinator?.moveToFav()
        }
        
        input.profileImage.bind { [weak self] data in
            guard let self else { return }
            userRepository.updateProfileImage(data)
            output.profileImageData.onNext(data)
        }
        
        input.dismiss.bind { [weak self] _ in
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
            output.updateDone.onNext(true)
        }
    }
    
    private func callRequest(group: DispatchGroup) {
        group.enter()
        trendingRepository.fetch(router: .trending) { [weak self] trending in
            defer { group.leave() }
            guard let self else { return }
            switch trending {
            case .success(let success):
                output.trendingCoinData.onNext(success.coins)
                output.trendingNFTData.onNext(success.nfts)
                print(success.coins, success.nfts)
            case .failure(let failure):
                output.error.onNext(checkError(error: failure))
            }
        }
    }
    
    private func callFavRequest(group: DispatchGroup) {
        guard let user = userRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        group.enter()
        coinRepository.fetch(router: .coin(ids: favoriteID)) { [weak self] coin in
            defer { group.leave() }
            guard let self,
                  !favoriteID.isEmpty else { return }
            switch coin {
            case .success(let success):
                output.favoriteData.onNext(success)
            case .failure(let failure):
                output.error.onNext(checkError(error: failure))
            }
        }
    }
    
    private func setImageData() {
        guard let data = userRepository.fetchImageData() else { return }
        output.profileImageData.onNext(data)
    }
    
    func showAlert(error: CCError) {
        coordinator?.showAlert(message: error.description,
                               okButtonTitle: CCConst.Ments.dismiss.text,
                               primaryButtonTitle: CCConst.Ments.retry.text) { [weak self] in
            guard let self else { return }
            input.viewWillAppear.onNext(())
        }
    }
}
