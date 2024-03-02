//
//  FavoriteCoordinator.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

final class FavoriteCoordinator: Coordinator {

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
        print("FavoriteCoordinator 해제")
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
}
