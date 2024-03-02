//
//  UserViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/2/24.
//

import UIKit

final class UserViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: UserViewModel
    
    // MARK: - Lifecycles
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
