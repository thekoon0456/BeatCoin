//
//  File.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

import SnapKit

final class FavoriteViewController: BaseViewController {
    
    // MARK: - Properties
    let viewModel = FavoriteViewModel()
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (CCLayout.width.value / 2) - 24
        layout.itemSize = .init(width: width, height: width)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = .init(top: 16, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.onNext(())
    }
    
    // MARK: - Helpers
    
    func bind() {
        viewModel.outputCoinData.bind { [weak self] coins in
            guard let self else { return }
            print(coins)
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
        navigationItem.title = CCConst.NaviTitle.favorite.name
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.outputCoinData.currentValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell
        else { return UICollectionViewCell() }
        cell.configureCell(viewModel.outputCoinData.currentValue[indexPath.item])
        return cell
    }
    
}
