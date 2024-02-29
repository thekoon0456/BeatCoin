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
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        viewModel.inputSearchText.onNext(searchBar.text)
    }
    
    // MARK: - Selectors
    
    @objc private func favoriteButtonTapped(sender: UIButton) {
        viewModel.inputFavoriteButtonTapped.onNext(sender.tag)
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.outputCoinData.bind { [weak self] coin in
            guard let self else { return }
            tableView.reloadData()
        }
        
        viewModel.outputFavorite.bind { [weak self] _ in
            guard let self else { return }
            tableView.reloadData()
        }
        
        viewModel.outputFavoriteIndex.bind { [weak self] index in
            guard let self,
                  let index
            else { return }
            let indexPath = IndexPath(item: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            //modal
            setToast(index)
        }
    }
    
    private func setToast(_ index: Int) {
        guard let coin = viewModel.outputCoinData.currentValue?[index],
              let isFavorite = viewModel.outputFavorite.currentValue?[index] else { return }
        let toastMessage = isFavorite
        ? Toast.setFavorite(coin: coin.name)
        : Toast.deleteFavorite(coin: coin.name)
        let vc = ToastViewController(inputMessage: toastMessage)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
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
        
        cell.configureCell(data, keyword: searchBar.text, isFavorite: isFavorite, tag: indexPath.row)
        cell.favoriteButton.addTarget(self,
                                      action: #selector(favoriteButtonTapped),
                                      for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.outputCoinData.currentValue?[indexPath.row] else { return }
        let vc = ChartViewController()
        vc.viewModel.coinID = data.id
        navigationController?.pushViewController(vc, animated: true)
    }
}
