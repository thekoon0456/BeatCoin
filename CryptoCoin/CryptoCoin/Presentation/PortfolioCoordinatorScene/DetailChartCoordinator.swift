//
//  DetailChartCoordinator.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

protocol DetailChartCoordinatorDelegate: AnyObject {
    func removeChildCoordinator()
}

final class DetailChartCoordinator: Coordinator {

    // MARK: - Properties
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator]
    var type: CoordinatorType
    var coinID: String?
    weak var delegate: DetailChartCoordinatorDelegate?
    
    // MARK: - Lifecycles
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.type = .detailChart
    }
    
    deinit {
        print("DetailChartCoordinator 해제")
    }
    
    // MARK: - Helpers
    
    func start() {
        let vm = DetailChartViewModel(coordinator: self, coinID: coinID)
        let vc = DetailChartViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop() {
        delegate?.removeChildCoordinator()
        navigationController?.popViewController(animated: true)
    }
}
