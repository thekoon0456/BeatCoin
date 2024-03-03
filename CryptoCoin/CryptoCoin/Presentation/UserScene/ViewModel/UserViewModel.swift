//
//  UserViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import Foundation

final class UserViewModel: ViewModel {
    
    struct Input { }
    
    struct Output { }
    
    // MARK: - Properties
    
    weak var coordinator: UserCoordinator?
    let input = Input()
    let output = Output()
    
    // MARK: - Lifecycles
    
    init(coordinator: UserCoordinator?) {
        self.coordinator = coordinator
    }
}
