//
//  FavoriteViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class FavoriteViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear = Observable<Void?>(nil)
        let pushDetail = Observable<String?>(nil)
        let updateFavorite = Observable<[CoinEntity]?>(nil)
        let profileImage = Observable<Data?>(nil)
        let dismiss = Observable<Void?>(nil)
    }
    
    struct Output {
        let profileImageData = Observable<Data?>(nil)
        let coinData = Observable<[CoinEntity]>([])
        let error = Observable<CCError?>(nil)
    }
    
    // MARK: - Properties
    
    weak var coordinator: FavoriteCoordinator?
    private let repository = CoinRepository()
    private let userRepository = UserRepository()
    let input = Input()
    let output = Output()

    init(coordinator: FavoriteCoordinator?) {
        self.coordinator = coordinator
        transform()
    }
    
    private func transform() {
        input.viewWillAppear.bind { [weak self] tap in
            guard let self,
                  let user = userRepository.fetch() else { return }
            let favoriteID = Array(user.favoriteID)
            callRequest(ids: favoriteID)
            setImageData()
        }
        
        input.updateFavorite.bind { [weak self] coin in
            guard let self,
                  let coin,
                  let user = userRepository.fetch()  else { return }
            let favoriteID = Array(user.favoriteID)
            userRepository.updatefav(item: favoriteID)
            output.coinData.onNext(coin)
        }
        
        input.profileImage.bind { [weak self] data in
            guard let self else { return }
            userRepository.updateProfileImage(data)
            output.profileImageData.onNext(data)
        }
        
        input.pushDetail.bind { [weak self] id in
            guard let self else { return }
            coordinator?.pushToDetail(coinID: id)
        }
        
        input.dismiss.bind { [weak self] _ in
            guard let self else { return }
            dismiss()
        }
    }
    
    private func callRequest(ids: [String]?) {
        guard let ids,
              !ids.isEmpty else {
            output.coinData.onNext([])
            return
        }
        
        repository.fetch(router: .coin(ids: ids)) { [weak self] coin in
            guard let self else { return }
            switch coin {
            case .success(let success):
                output.coinData.onNext(success)
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
    
    func dismiss() {
        coordinator?.dismiss()
    }
}
