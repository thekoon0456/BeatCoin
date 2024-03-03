//
//  PortfolioViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

final class DetailChartViewModel: ViewModel {
    
    struct Input {
        let viewDidLoad = Observable<Void?>(nil)
        let coinName = Observable<String?>(nil)
        let favorite = Observable<String?>(nil)
    }
    
    struct Output {
        let coinData = Observable<[CoinEntity]>([])
        let favoriteData = Observable<Bool?>(nil)
        let error = Observable<CCError?>(nil)
        let toast = Observable<Toast?>(nil)
    }
    
    // MARK: - Properties
    
    weak var coordinator: DetailChartCoordinator?
    private let repository = CoinRepository()
    private let userRepository = UserRepository()
    private var coinID: String?
    let input = Input()
    let output = Output()

    // MARK: - Lifecycles
    
    init(coordinator: DetailChartCoordinator?, coinID: String?) {
        self.coordinator = coordinator
        self.coinID = coinID
        transform()
    }
    
    // MARK: - Helpers
    
    private func transform() {
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            callRequest(id: coinID)
            checkFavorite(id: coinID)
        }
        
        input.favorite.bind { [weak self] id in
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
                output.coinData.onNext(success)
            case .failure(let failure):
                output.error.onNext(checkError(error: failure))
            }
        }
    }
    
    private func setFavorite(id: String) {
        guard let user = userRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        
        if favoriteID.contains(id) {
            userRepository.deleteFav(id)
            output.favoriteData.onNext(false)
            output.toast.onNext(.deleteFavorite(coin: id))
            return
        }
        
        //추가
        guard favoriteID.count < 10 else {
            output.toast.onNext(.maxFavorite)
            return
        }
        
        userRepository.createFav(id)
        output.favoriteData.onNext(true)
        output.toast.onNext(.setFavorite(coin: id))
    }
    
    private func checkFavorite(id: String?) {
        guard let id else { return }
        guard let user = userRepository.fetch() else { return }
        let favoriteID = Array(user.favoriteID)
        
        if favoriteID.contains(id) {
            output.favoriteData.onNext(true)
        } else {
            output.favoriteData.onNext(false)
        }
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
            input.viewDidLoad.onNext(())
        })
    }
    
    func showToast(_ type: Toast) {
        coordinator?.showToast(type)
    }
    
    func pop() {
        coordinator?.pop()
    }
    
    func removeChildCoordinator() {
        coordinator?.delegate?.removeChildCoordinator()
    }
}
