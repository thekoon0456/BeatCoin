//
//  FavoriteCoordinator.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

final class FavoriteCoordinator: Coordinator, DetailChartCoordinatorDelegate {

    // MARK: - Properties
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator]
    var type: CoordinatorType
    
    // MARK: - Lifecycles
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.type = .favorite
    }
    
    deinit {
        print("DEBUG: FavoriteCoordinator 해제")
    }
    
    // MARK: - Helpers
    
    func start() {
        let vm = FavoriteViewModel(coordinator: self)
        let vc = FavoriteViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(named: CCDesign.TabIcon.portfolio.inactive),
                                     selectedImage: UIImage(named: CCDesign.TabIcon.portfolio.name))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToDetail(coinID: String?) {
        let coordinator = DetailChartCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.coinID = coinID
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func present(vc: UIImagePickerController) {
        navigationController?.present(vc, animated: true)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
}
