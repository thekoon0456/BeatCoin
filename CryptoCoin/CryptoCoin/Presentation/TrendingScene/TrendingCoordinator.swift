//
//  TrendingCoordinator.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

final class TrendingCoordinator: NSObject, Coordinator, DetailChartCoordinatorDelegate {

    // MARK: - Properties
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator]
    var type: CoordinatorType
    
    // MARK: - Lifecycles
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.type = .trending
    }
    
    deinit {
        print("TrendingCoordinator 해제")
    }
    
    // MARK: - Helpers
    
    func start() {
        let vm = TrendingViewModel(coordinator: self)
        let vc = TrendingViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(named: CCDesign.TabIcon.trending.inactive),
                                     selectedImage: UIImage(named: CCDesign.TabIcon.trending.name))
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
