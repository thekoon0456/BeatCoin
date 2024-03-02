//
//  TrendingCoordinator.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

final class TrendingCoordinator: Coordinator {

    // MARK: - Properties
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator]
    var type: CoordinatorType
    
    // MARK: - Lifecycles
    
    init(navigationController: UINavigationController? = nil) {
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
        navigationController?.pushViewController(vc, animated: false)
    }
}