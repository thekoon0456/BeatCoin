//
//  TabBarViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    let trendingVC = TrendingViewController()
    let searchVC = CoinSearchViewController()
    let favoriteVC = FavoriteViewController()
    let personVC = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        let vcArr = [trendingVC, searchVC, favoriteVC, personVC]
        let navVcArr = vcArr.map { UINavigationController(rootViewController: $0) }
        let iconArr = CCDesign.TabIcon.allCases

        for i in 0..<navVcArr.count {
            navVcArr[i].tabBarItem = UITabBarItem(title: nil,
                                                  image: UIImage(named: iconArr[i].inactive),
                                                  selectedImage: UIImage(named: iconArr[i].name))
        }
        
        self.viewControllers = navVcArr
    }
}
