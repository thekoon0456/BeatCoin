//
//  TrendingViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

final class TrendingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = TrendingRepository()
        repo.fetch(router: .trending) { trending in
            print(trending)
        }
    }
    
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = CCConst.NaviTitle.trending.name
    }
}
