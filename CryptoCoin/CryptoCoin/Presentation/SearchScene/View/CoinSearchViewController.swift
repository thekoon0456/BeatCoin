//
//  CoinSearchViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

final class CoinSearchViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: CoinSearchViewModel
    private var updateTimer: Timer?
    
    private lazy var searchController = UISearchController().then {
        $0.searchBar.placeholder = CCConst.Ments.searchPlaceHolder.text
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
    
    private let backgroundView = UIImageView().then {
        $0.image = UIImage(systemName: CCDesign.Icon.coin.name)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = CCDesign.Color.tintColor.color
        $0.alpha = 0.3
    }
    
    private lazy var profileButton = UIButton().then {
        $0.setImage(UIImage(named: CCDesign.TabIcon.user.name), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.layer.borderColor = CCDesign.Color.tintColor.color.cgColor
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
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
        
        viewModel.input.searchText.onNext(searchController.searchBar.text)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeTimer()
    }
    
    // MARK: - Selectors
    
    @objc func imageButtonTapped() {
        let vc = UIImagePickerController()
        vc.delegate = self
        viewModel.coordinator?.present(vc: vc)
    }
    
    @objc private func favoriteButtonTapped(sender: UIButton) {
        viewModel.input.favorite.onNext(sender.tag)
    }
    
    @objc func refreshData() {
        viewModel.input.searchText.onNext(searchController.searchBar.text)
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.output.coinData.bind { [weak self] coin in
            guard let self,
                  let coin else { return }
            tableView.backgroundView = coin.isEmpty ? backgroundView : nil
            tableView.reloadData()
        }
        
        viewModel.output.favoriteIndex.bind { [weak self] index in
            guard let self,
                  let index else { return }
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        }
        
        viewModel.output.profileImageData.bind { [weak self] data in
            guard let self,
                  let data else { return }
            profileButton.setImage(UIImage(data: data), for: .normal)
        }
        
        viewModel.output.error.bind { [weak self] error in
            guard let self,
                  let error else { return }
            viewModel.showAlert(error: error)
        }
        
        viewModel.output.toast.bind { [weak self] toast in
            guard let self,
                  let toast else { return }
            viewModel.showToast(toast)
        }
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        view.addSubviews(tableView)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = CCConst.NaviTitle.search.name
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
}

// MARK: - Timer

extension CoinSearchViewController {
    
    private func setAutoUpdate() {
        updateTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                           target: self,
                                           selector: #selector(refreshData),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    private func removeTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
}

// MARK: - ImagePicker

extension CoinSearchViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewModel.input.dismiss.onNext(())
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewModel.input.profileImage.onNext(pickedImage.pngData())
        }
        viewModel.input.dismiss.onNext(())
    }
}

// MARK: - SearchBar

extension CoinSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.searchText.onNext(searchBar.text)
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
        viewModel.output.coinData.currentValue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell,
              let data = viewModel.output.coinData.currentValue?[indexPath.row],
              let isFavorite = viewModel.output.favoriteData.currentValue?[indexPath.row]
        else { return UITableViewCell() }
        
        cell.configureCell(data, keyword: searchController.searchBar.text, isFavorite: isFavorite, tag: indexPath.row)
        cell.favoriteButton.addTarget(self,
                                      action: #selector(favoriteButtonTapped),
                                      for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.output.coinData.currentValue?[indexPath.row] else { return }
        viewModel.input.pushDetail.onNext(data.id)
    }
}
