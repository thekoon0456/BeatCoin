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
        childCoordinators.append(trendingCoordinator)
        trendingCoordinator.start()
        
        let searchNav = UINavigationController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNav)
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
        
        let favoriteNav = UINavigationController()
        let favoriteCoordinator = FavoriteCoordinator(navigationController: favoriteNav)
        childCoordinators.append(favoriteCoordinator)
        favoriteCoordinator.start()
        
//        let userNav = UINavigationController()
//        let userCoordinator = UserCoordinator(navigationController: userNav)
//        childCoordinators.append(userCoordinator)
//        userCoordinator.start()
        
        tabBarController.viewControllers = [trendingNav, searchNav, favoriteNav]
        navigationController?.pushViewController(tabBarController, animated: false)
    }
}
