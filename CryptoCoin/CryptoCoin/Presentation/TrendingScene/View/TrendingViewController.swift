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
    private let viewModel: TrendingViewModel
    
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
    
    // MARK: - Lifecycles
    
    init(viewModel: TrendingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputViewWillAppear.onNext(())
        navigationItem.title = CCConst.NaviTitle.trending.name
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.outputUpdateComplete.bind { [weak self] isComplete in
            guard let self,
                  isComplete == true
            else { return }
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
    }
}

// MARK: - CollectionView

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .favorite:
            return viewModel.outputFavoriteCoinData.currentValue.count >= 2 ? viewModel.outputFavoriteCoinData.currentValue.count : 0
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
            let data = viewModel.outputFavoriteCoinData.currentValue[indexPath.item]
            cell.configureCell(data)
            return cell
        case .topCoin:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCell.identifier, for: indexPath) as? TrendingCell,
                  let data =  viewModel.outputTrendingCoin.currentValue?[indexPath.item]
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(data)
            return cell
        case .topNFT:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCell.identifier, for: indexPath) as? TrendingCell,
                  let data =  viewModel.outputTrendingNFT.currentValue?[indexPath.item]
            else {
                return UICollectionViewCell()
            }
            cell.configureNFTCell(data, index: indexPath.item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .favorite:
            let data = viewModel.outputFavoriteCoinData.currentValue[indexPath.item]
            viewModel.inputPushDetail.onNext(data.id)
            print(#function)
//            let vc = DetailChartViewController()
//            vc.viewModel.coinID = data.id
//            navigationItem.title = .none
//            navigationController?.pushViewController(vc, animated: true)
            break
        case .topCoin:
            guard let data = viewModel.outputTrendingCoin.currentValue?[indexPath.item] else { return }
            viewModel.inputPushDetail.onNext(data.id)
//            let vc = DetailChartViewController()
//            vc.viewModel.coinID = data.id
//            navigationItem.title = .none
//            navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    //헤더뷰
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
            default:
                break
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - CollectionView Layout

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
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch Section(rawValue: section) {
            case .favorite:
                guard self.viewModel.outputFavoriteCoinData.currentValue.count >= 2 else { return nil }
                           
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6),
                                                       heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                              leading: 12,
                                                              bottom: 12,
                                                              trailing: 0)
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
                group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                              leading: 0,
                                                              bottom: 0,
                                                              trailing: 12)
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
