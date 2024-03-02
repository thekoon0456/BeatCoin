//
//  AppCoordinator.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

final class AppCoordinator: Coordinator {

    // MARK: - Properties
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator]
    var type: CoordinatorType
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.type = .app
    }
    
    // MARK: - Helpers
    
    func start() {
        let tabBarController = UITabBarController()
        let trendingNav = UINavigationController()
        let trendingCoordinator = TrendingCoordinator(navigationController: trendingNav)
        trendingCoordinator.start()
        
        let searchNav = UINavigationController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNav)
        searchCoordinator.start()
        
        let favoriteNav = UINavigationController()
        let favoriteCoordinator = FavoriteCoordinator(navigationController: favoriteNav)
        favoriteCoordinator.start()
        
        let userNav = UINavigationController()
        let userCoordinator = UserCoordinator(navigationController: userNav)
        userCoordinator.start()
        
        tabBarController.viewControllers = [trendingNav, searchNav, favoriteNav, userNav]
        navigationController?.pushViewController(tabBarController, animated: false)
    }
}
