//
//  CoinSearchViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

final class CoinSearchViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = SearchRepository()
        repo.fetchTrending(name: "bitcoin") { searchCoin in
            print(searchCoin)
        }
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = CCConst.NaviTitle.search.name
    }
}
