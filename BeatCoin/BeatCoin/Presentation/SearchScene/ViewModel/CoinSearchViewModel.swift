//
//  CoinSearchViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class CoinSearchViewModel: ViewModel {
    
    struct Input {
        let pushDetail = Observable<String?>(nil)
        let searchText = Observable<String?>(nil)
        let favorite = Observable<Int?>(nil)
        let profileImage = Observable<Data?>(nil)
        let dismiss = Observable<Void?>(nil)
    }
    
    struct Output {
        let coinData = Observable<[CoinEntity]?>(nil)
        let favoriteData = Observable<[Bool]?>(nil)
        let favoriteIndex = Observable<Int?>(nil)
        let profileImageData = Observable<Data?>(nil)
        let toast = Observable<Toast?>(nil)
        let error = Observable<CCError?>(nil)
    }
    
    // MARK: - Properties
    
    weak var coordinator: SearchCoordinator?
    private let repository = SearchRepository()
    private let userRepository = UserRepository()
    let input = Input()
    let output = Output()

    init(coordinator: SearchCoordinator?) {
        self.coordinator = coordinator
        transform()
    }
    
    private func transform() {
        input.searchText.bind { [weak self] id in
            guard let self else { return }
            callRequest(id: id)
            setImageData()
        }
        
        input.favorite.bind { [weak self] index in
            guard let self,
                  let index,
                  let coinData = output.coinData.currentValue else { return }
            favoriteToggle(coin: coinData[index])
            setFavorite(coinData)
            output.favoriteIndex.onNext(index)
        }
        
        input.pushDetail.bind { [weak self] id in
            guard let self else { return }
            coordinator?.pushToDetail(coinID: id)
        }
        
        input.profileImage.bind { [weak self] data in
            guard let self else { return }
            userRepository.updateProfileImage(data)
            output.profileImageData.onNext(data)
        }
        
        input.dismiss.bind { [weak self] _ in
            guard let self else { return }
            dismiss()
        }
    }
    
    private func callRequest(id: String?) {
        guard let id else { return }
        repository.fetch(router: .searchCoin(query: id)) { [weak self] coin in
            guard let self else { return }
            switch coin {
            case .success(let success):
                setFavorite(success)
                output.coinData.onNext(success)
            case .failure(let failure):
                output.error.onNext(checkError(error: failure))
            }
        }
    }
    
    private func setFavorite(_ coin: [CoinEntity]) {
        guard let user = userRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        let isFavorite = coin.map {
            favoriteID.contains($0.id) ? true : false
        }
        
        output.favoriteData.onNext(isFavorite)
    }
    
    private func favoriteToggle(coin: CoinEntity) {
        guard let user = userRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        //삭제
        if favoriteID.contains(coin.id) {
            userRepository.deleteFav(coin.id)
            output.toast.onNext(.deleteFavorite(coin: coin.id))
            return
        }
        
        //추가
        guard favoriteID.count < 10 else {
            output.toast.onNext(.maxFavorite)
            return
        }
        
        userRepository.createFav(coin.id)
        output.toast.onNext(.setFavorite(coin: coin.id))
    }
    
    private func setImageData() {
        guard let data = userRepository.fetchImageData() else { return }
        output.profileImageData.onNext(data)
    }
    
    func showAlert(error: CCError) {
        coordinator?.showAlert(message: error.description,
                               okButtonTitle: CCConst.Ments.dismiss.text,
                               primaryButtonTitle: CCConst.Ments.retry.text,
                               okAction: { [weak self] in
            guard let self else { return }
            pop()
        }, primaryAction: { [weak self] in
            guard let self else { return }
            input.searchText.onNext(input.searchText.currentValue)
        })
    }
    
    func showToast(_ type: Toast) {
        coordinator?.showToast(type)
    }
    
    func pop() {
        coordinator?.pop()
    }
    
    func dismiss() {
        coordinator?.dismiss()
    }
}
