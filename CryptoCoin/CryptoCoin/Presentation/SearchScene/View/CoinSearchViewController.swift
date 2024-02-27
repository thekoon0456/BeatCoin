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
        
//        APIService.shared.callRequest(api: .searchCoin(query: "bitcoin"), type: SearchDTO.self) { result in
//            print(result)
//        }
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
