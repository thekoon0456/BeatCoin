//
//  TrendingViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

import SnapKit

final class TrendingViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel = TrendingViewModel()
    private lazy var collectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: setLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(TrendingFavoriteCell.self,
                    forCellWithReuseIdentifier: TrendingFavoriteCell.identifier)
        cv.register(TrendingCell.self,
                    forCellWithReuseIdentifier: TrendingCell.identifier)
        return cv
    }()
    
    private let headerLabel = UILabel()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.inputViewDidLoad.onNext(())
        bind()
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.outputFavoriteCoinData.bind { [weak self] _ in
            guard let self else { return }
            collectionView.reloadData()
        }
        
        viewModel.outputTrendingCoin.bind { [weak self] _ in
            guard let self else { return }
            collectionView.reloadData()
        }
        
        viewModel.outputTrendingNFT.bind { [weak self] _ in
            guard let self else { return }
            collectionView.reloadData()
        }
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = CCConst.NaviTitle.trending.name
    }
}

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        Section(rawValue: section)?.column ?? 0
////        viewModel.outputFavoriteCoinData.currentValue.count
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .favorite:
            return viewModel.outputFavoriteCoinData.currentValue.count
        case .topCoin:
            return viewModel.outputTrendingCoin.currentValue?.count ?? 0
        case .topNFT:
            return viewModel.outputTrendingNFT.currentValue?.count ?? 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .favorite:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingFavoriteCell.identifier, for: indexPath) as? TrendingFavoriteCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(viewModel.outputFavoriteCoinData.currentValue[indexPath.item])
            return cell
        case .topCoin:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCell.identifier, for: indexPath) as? TrendingCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(viewModel.outputTrendingCoin.currentValue![indexPath.item])
            return cell
        case .topNFT:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCell.identifier, for: indexPath) as? TrendingCell else {
                return UICollectionViewCell()
            }
            cell.configureNFTCell(viewModel.outputTrendingNFT.currentValue![indexPath.item], index: indexPath.item)
            return cell
        }
    }
}


// MARK: - Layout

extension TrendingViewController {
    
    enum Section: Int, CaseIterable {
        case favorite
        case topCoin
        case topNFT
        
        var column: Int {
            switch self {
            case .favorite:
                1
            case .topCoin:
                3
            case .topNFT:
                3
            }
        }
        
        var title: String {
            switch self {
            case .favorite:
                "My Favorite"
            case .topCoin:
                "Top 15 Coin"
            case .topNFT:
                "Top7 NFT"
            }
        }
    }
    
    private func setLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection in
            switch Section(rawValue: section) {
            case .favorite:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                             leading: 12,
                                                             bottom: 12,
                                                             trailing: 0)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6),
                                                       heightDimension: .fractionalHeight(0.3))

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                              heightDimension: .absolute(50)),
                                                            elementKind: Section.favorite.title,
                                                            alignment: .topLeading)]
                section.orthogonalScrollingBehavior = .groupPaging
//                section.orthogonalScrollingBehavior = .groupPagingCentered
                return section
            case .topCoin, .topNFT, .none:
                let itemInset: CGFloat = 2.5
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(0.3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                       heightDimension: .fractionalHeight(1/3))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                              heightDimension: .absolute(50)),
                                                            elementKind: Section.topCoin.title,
                                                            alignment: .topLeading)]
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            }
        }
        
        layout.configuration.scrollDirection = .horizontal
        return layout
    }
}


//enum TrendingSection: Int, CaseIterable {
//    case myFavorite
//    case top15Coin
//    case top7NFT
//
//    var title: String {
//        switch self {
//        case .myFavorite:
//            "My Favorite"
//        case .top15Coin:
//            "Top 15 Coin"
//        case .top7NFT:
//            "Top7 NFT"
//        }
//    }
//}

//
//extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        TrendingSection.allCases.count
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UILabel().then {
//            $0.text = TrendingSection.allCases[section].title
//            $0.font = .boldSystemFont(ofSize: 24)
//        }
//        return header
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        200
//    }
//}
