//
//  ChartViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

import Charts

final class ChartViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = CoinRepository()
        repo.fetch(router: .coin(ids: ["solana"])) { entity in
            print(entity)
        }
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "Solana"
    }
}
