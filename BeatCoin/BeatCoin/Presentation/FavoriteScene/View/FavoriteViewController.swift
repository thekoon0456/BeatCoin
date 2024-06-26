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
    
    let viewModel: FavoriteViewModel
    private var updateTimer: Timer?
    
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
    
    private lazy var profileButton = UIButton().then {
        $0.setImage(UIImage(named: CCDesign.TabIcon.user.name), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.layer.borderColor = CCDesign.Color.tintColor.color.cgColor
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
    }
    
    private let backgroundView = UIImageView().then {
        $0.image = UIImage(systemName: CCDesign.Icon.coin.name)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = CCDesign.Color.tintColor.color
        $0.alpha = 0.3
    }
    
    private let iconView = UIImageView().then {
        $0.image = UIImage(systemName: CCDesign.Icon.icon.name)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = CCDesign.Color.tintColor.color
        $0.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: FavoriteViewModel) {
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
        
        viewModel.input.viewWillAppear.onNext(())
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
    
    @objc func refreshData() {
        viewModel.input.viewWillAppear.onNext(())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    
    func bind() {
        viewModel.output.coinData.bind { [weak self] coins in
            guard let self else { return }
            collectionView.backgroundView = coins.isEmpty ? backgroundView : nil
            collectionView.reloadData()
        }
        
        viewModel.output.profileImageData.bind { [weak self] data in
            guard let self,
                  let data
            else { return }
            profileButton.setImage(UIImage(data: data), for: .normal)
        }
        
        viewModel.output.error.bind { [weak self] error in
            guard let self,
                  let error else { return }
            viewModel.showAlert(error: error)

        }
    }

    // MARK: - Configure
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = CCConst.NaviTitle.favorite.name
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
}

// MARK: - Timer

extension FavoriteViewController {
    
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

extension FavoriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.coinData.currentValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell
        else { return UICollectionViewCell() }
        cell.configureCell(viewModel.output.coinData.currentValue[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.output.coinData.currentValue[indexPath.item]
        viewModel.input.pushDetail.onNext(data.id)
    }
}

extension FavoriteViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    //드래그 아이템 필수구현
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        []
    }
    
    //드래그 설정되있으면 move
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    //드래그 아이템 업데이트
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        var data = viewModel.output.coinData.currentValue
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                let temp = data[sourceIndexPath.item]
                data.remove(at: sourceIndexPath.item)
                data.insert(temp, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                viewModel.input.updateFavorite.onNext(data)
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
        
        //이동하고 업데이트
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
}
