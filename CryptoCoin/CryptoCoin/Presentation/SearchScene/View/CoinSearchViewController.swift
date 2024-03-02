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
    
    private let viewModel: CoinSearchViewModel
    private var updateTimer: Timer?
    
    private lazy var searchController = UISearchController().then {
        $0.searchBar.placeholder = "Search Coin"
        $0.searchBar.backgroundColor = .clear
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.tintColor = CCDesign.Color.tintColor.color
        $0.searchBar.delegate = self
        $0.definesPresentationContext = true
    }
    
    private lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: CoinSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        // MARK: - 10초마다 요청
//        setAutoUpdate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputSearchText.onNext(searchController.searchBar.text)
        navigationItem.title = CCConst.NaviTitle.search.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateTimer?.invalidate()
    }
    
    // MARK: - Selectors
    
    @objc private func favoriteButtonTapped(sender: UIButton) {
        viewModel.inputFavoriteButtonTapped.onNext(sender.tag)
    }
    
    @objc func refreshData() {
        viewModel.inputSearchText.onNext(searchController.searchBar.text)
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
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            
            //modal
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                setFavoriteToast(index)
            }
        }
        
        viewModel.outputError.bind { [weak self] error in
            guard let self,
                  let error
            else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                if error == .maxFavorite {
                    setMaxToast()
                    return
                }
                
                showAlert(message: error.description,
                          primaryButtonTitle: "재시도하기",
                          okButtonTitle: "취소") { [weak self] _ in
                    guard let self else { return }
                    viewModel.inputSearchText.onNext((searchController.searchBar.text))
                    dismiss(animated: true)
                } okAction: { [weak self] _ in
                    guard let self else { return }
                    dismiss(animated: true)
                }
            }
        }
    }
    
    func setAutoUpdate() {
        updateTimer = Timer.scheduledTimer(timeInterval: 10.0,
                             target: self,
                             selector: #selector(refreshData),
                             userInfo: nil,
                             repeats: true)
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        view.addSubviews(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backButtonDisplayMode = .minimal
    }
}

// MARK: - Toast

extension CoinSearchViewController {
    
    private func setFavoriteToast(_ index: Int) {
        guard let coin = viewModel.outputCoinData.currentValue?[index],
              let isFavorite = viewModel.outputFavorite.currentValue?[index] else { return }
        let toastMessage = isFavorite
        ? Toast.setFavorite(coin: coin.name)
        : Toast.deleteFavorite(coin: coin.name)
        let vc = ToastViewController(inputMessage: toastMessage)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            vc.dismiss(animated: true)
        }
    }
    
    private func setMaxToast() {
        let vc = ToastViewController(inputMessage: .maxFavorite)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            vc.dismiss(animated: true)
        }
    }
}

// MARK: - SearchBar

extension CoinSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchText.onNext(searchBar.text)
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let inputText = searchBar.text,
              inputText.count < 30 else { return false } //30자 제한
        
        let input = (inputText as NSString).replacingCharacters(in: range, with: text)
        let trimmedText = input.trimmingCharacters(in: .whitespaces)
        let hasWhiteSpace = input != trimmedText
        return !hasWhiteSpace
    }
}

// MARK: - TableView

extension CoinSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputCoinData.currentValue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell,
              let data = viewModel.outputCoinData.currentValue?[indexPath.row],
              let isFavorite = viewModel.outputFavorite.currentValue?[indexPath.row]
        else { return UITableViewCell() }
        
        cell.configureCell(data, keyword: searchController.searchBar.text, isFavorite: isFavorite, tag: indexPath.row)
        cell.favoriteButton.addTarget(self,
                                      action: #selector(favoriteButtonTapped),
                                      for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let data = viewModel.outputCoinData.currentValue?[indexPath.row] else { return }
//        let vc = DetailChartViewController()
//        vc.viewModel.coinID = data.id
//        navigationItem.title = .none
//        navigationController?.pushViewController(vc, animated: true)
    }
}
