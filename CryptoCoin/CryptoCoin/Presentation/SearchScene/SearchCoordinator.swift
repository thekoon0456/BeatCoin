//
//  SearchCoordinator.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

final class SearchCoordinator: Coordinator, DetailChartCoordinatorDelegate {

    // MARK: - Properties
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator]
    var type: CoordinatorType
    
    // MARK: - Lifecycles
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.type = .search
    }
    
    deinit {
        print("SearchCoordinator 해제")
    }
    
    // MARK: - Helpers
    
    func start() {
        let vm = CoinSearchViewModel(coordinator: self)
        let vc = CoinSearchViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(named: CCDesign.TabIcon.search.inactive),
                                     selectedImage: UIImage(named: CCDesign.TabIcon.search.name))
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
}
