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
        let refreshControl = UIRefreshControl().then {
            $0.tintColor = CCDesign.Color.tintColor.color
            $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        }
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifier)
        cv.refreshControl = refreshControl
        cv.dragInteractionEnabled = true
        cv.dragDelegate = self
        cv.dropDelegate = self
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.reloadData()
    }
    
    // MARK: - Helpers
    
    func bind() {
        viewModel.outputCoinData.bind { [weak self] coins in
            guard let self else { return }
            collectionView.reloadData()
        }
        
        viewModel.outputError.bind { [weak self] error in
            guard let self,
                  let error
            else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                showAlert(message: error.description,
                          primaryButtonTitle: "재시도하기",
                          okButtonTitle: "취소") { [weak self] _ in
                    guard let self else { return }
                    viewModel.inputViewWillAppear.onNext(())
                    dismiss(animated: true)
                } okAction: { [weak self] _ in
                    guard let self else { return }
                    dismiss(animated: true)
                }
            }
        }
    }
    
    @objc func refreshData() {
        viewModel.inputViewWillAppear.onNext(())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            collectionView.refreshControl?.endRefreshing()
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
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.outputCoinData.currentValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell
        else { return UICollectionViewCell() }
        cell.configureCell(viewModel.outputCoinData.currentValue[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.outputCoinData.currentValue[indexPath.item]
        let vc = ChartViewController()
        vc.viewModel.coinID = data.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoriteViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        []
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        var data = viewModel.outputCoinData.currentValue
        if
            let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                let temp = data[sourceIndexPath.item]
                data.remove(at: sourceIndexPath.item)
                data.insert(temp, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                viewModel.outputCoinData.onNext(data)
            }) { done in
                
            }
            
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
         if let indexPath = coordinator.destinationIndexPath {
             destinationIndexPath = indexPath
         } else {
             let row = collectionView.numberOfItems(inSection: 0)
             destinationIndexPath = IndexPath(item: row - 1, section: 0)
         }
         
         if coordinator.proposal.operation == .move {
             reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
         }
     }
}
