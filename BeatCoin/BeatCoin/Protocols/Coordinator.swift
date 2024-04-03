//
//  Coordinator.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

enum CoordinatorType {
    case app
    case main
    case trending
    case search
    case favorite
    case user
    case detailChart
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    var type: CoordinatorType { get }
    
    func start()
    func removeChildCoordinator()
}

extension Coordinator {
    
    func removeChildCoordinator() {
        childCoordinators.removeAll()
    }
}
