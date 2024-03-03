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
    let userRepository = UserRepository()
    
    let inputPushDetail = Observable<String?>(nil)
    let inputSearchText = Observable<String?>(nil)
    let inputFavoriteButtonTapped = Observable<Int?>(nil)
    let inputProfileImage = Observable<Data?>(nil)
    let inputDismiss = Observable<Void?>(nil)
    
    let outputCoinData = Observable<[CoinEntity]?>(nil)
    let outputFavorite = Observable<[Bool]?>(nil)
    let outputFavoriteIndex = Observable<Int?>(nil)
    let outputToast = Observable<Toast?>(nil)
    let outputError = Observable<CCError?>(nil)
    let outputProfileImageData = Observable<Data?>(nil)
    
    init(coordinator: SearchCoordinator?) {
        self.coordinator = coordinator
        transform()
    }
    
    private func transform() {
        inputSearchText.bind { [weak self] id in
            guard let self else { return }
            callRequest(id: id)
            setImageData()
        }
        
        inputFavoriteButtonTapped.bind { [weak self] index in
            guard let self,
                  let index,
                  let coinData = outputCoinData.currentValue else { return }
            favoriteToggle(coin: coinData[index])
            setFavorite(coinData)
            outputFavoriteIndex.onNext(index)
        }
        
        inputPushDetail.bind { [weak self] id in
            guard let self else { return }
            coordinator?.pushToDetail(coinID: id)
        }
        
        inputProfileImage.bind { [weak self] data in
            guard let self else { return }
            userRepository.updateProfileImage(data)
            outputProfileImageData.onNext(data)
        }
        
        inputDismiss.bind { [weak self] _ in
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
                outputCoinData.onNext(success)
            case .failure(let failure):
                outputError.onNext(checkError(error: failure))
            }
        }
    }
    
    private func setFavorite(_ coin: [CoinEntity]) {
        guard let user = userRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        let isFavorite = coin.map {
            favoriteID.contains($0.id) ? true : false
        }
        
        outputFavorite.onNext(isFavorite)
    }
    
    private func favoriteToggle(coin: CoinEntity) {
        guard let user = userRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        //삭제
        if favoriteID.contains(coin.id) {
            userRepository.deleteFav(coin.id)
            outputToast.onNext(.deleteFavorite(coin: coin.id))
            return
        }
        
        //추가
        guard favoriteID.count < 10 else {
            outputToast.onNext(.maxFavorite)
            return
        }
        
        userRepository.createFav(coin.id)
        outputToast.onNext(.setFavorite(coin: coin.id))
    }
    
    private func setImageData() {
        guard let data = userRepository.fetchImageData() else { return }
        outputProfileImageData.onNext(data)
    }
    
    func showAlert(error: CCError) {
        coordinator?.showAlert(message: error.description,
                               okButtonTitle: "되돌아가기",
                               primaryButtonTitle: "재시도하기",
                               okAction: { [weak self] in
            guard let self else { return }
            pop()
        }, primaryAction: { [weak self] in
            guard let self else { return }
            inputSearchText.onNext(inputSearchText.currentValue)
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
