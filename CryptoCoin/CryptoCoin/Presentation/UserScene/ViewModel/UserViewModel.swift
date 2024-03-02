//
//  UserViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import Foundation

final class UserViewModel: ViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: UserCoordinator?
    
    // MARK: - Lifecycles
    
    init(coordinator: UserCoordinator?) {
        self.coordinator = coordinator
    }
    
}
