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
        cv.register(TrendingHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: TrendingHeaderView.identifier)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: TrendingHeaderView.identifier,
                                                                               for: indexPath) as? TrendingHeaderView
            else {
                return UICollectionReusableView()
            }
            
            switch Section(rawValue: indexPath.section) {
            case .favorite:
                header.setTitle(Section.favorite.title)
            case .topCoin:
                header.setTitle(Section.topCoin.title)
            case .topNFT:
                header.setTitle(Section.topNFT.title)
            case .none:
                break
            }
            
            return header
        default:
            return UICollectionReusableView()
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
            case .topCoin, .topNFT:
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
                                                            elementKind:  UICollectionView.elementKindSectionHeader,
                                                            alignment: .topLeading)]
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            case .topCoin, .topNFT, .none:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(0.3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                       heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                              heightDimension: .absolute(50)),
                                                            elementKind:  UICollectionView.elementKindSectionHeader,
                                                            alignment: .topLeading)]
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            }
        }
        
        layout.configuration.scrollDirection = .horizontal
        return layout
    }
}
