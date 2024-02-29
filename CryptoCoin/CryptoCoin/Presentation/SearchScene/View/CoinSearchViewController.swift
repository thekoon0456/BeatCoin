//
//  CoinSearchViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

import Alamofire

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
        $0.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.outputCoinData.bind { [weak self] coin in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
    // MARK: - Configure
    
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchText.onNext(searchBar.text)
        view.endEditing(true)
    }
}

extension CoinSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputCoinData.currentValue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell,
              let data = viewModel.outputCoinData.currentValue?[indexPath.row],
              let isFavorite = viewModel.outputFavorite.currentValue?[indexPath.row]
        else { return UITableViewCell() }
        cell.configureCell(data, isFavorite: isFavorite)
        return cell
    }
}
