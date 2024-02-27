//
//  CoinSearchViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

final class CoinSearchViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel = CoinSearchViewModel()
    
    private lazy var searchBar = UISearchBar().then {
        $0.placeholder = "Search Coin"
        $0.backgroundColor = .clear
        $0.searchBarStyle = .minimal
        $0.tintColor = CCDesign.Color.tintColor.color
        $0.delegate = self
    }
    
    private lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Helpers
    
    override func configureHierarchy() {
        view.addSubviews(searchBar, tableView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = CCConst.NaviTitle.search.name
    }
}

extension CoinSearchViewController: UISearchBarDelegate {
    
}

extension CoinSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
