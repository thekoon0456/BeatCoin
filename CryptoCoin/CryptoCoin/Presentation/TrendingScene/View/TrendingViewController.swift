//
//  TrendingViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

import SnapKit

enum TrendingSection: Int, CaseIterable {
    case myFavorite
    case top15Coin
    case top7NFT
    
    var title: String {
        switch self {
        case .myFavorite:
            "My Favorite"
        case .top15Coin:
            "Top 15 Coin"
        case .top7NFT:
            "Top7 NFT"
        }
    }
}

final class TrendingViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel = TrendingViewModel()
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = TrendingRepository()
        repo.fetch(router: .trending) { entity in
            print(entity)
        }
    }
    
    // MARK: - Helpers
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = CCConst.NaviTitle.trending.name
    }
}

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TrendingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel().then {
            $0.text = TrendingSection.allCases[section].title
            $0.font = .boldSystemFont(ofSize: 24)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}

