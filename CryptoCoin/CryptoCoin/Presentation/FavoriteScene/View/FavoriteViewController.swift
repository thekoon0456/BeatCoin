//
//  File.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

final class FavoriteViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = CoinRepository()
        repo.fetch(ids: "bitcoin", "wrapped-bitcoin") { coins in
            print(coins)
        }
    }
    
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = CCConst.NaviTitle.favorite.name
    }
}
