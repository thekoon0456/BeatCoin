//
//  UIViewController+.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/29/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String = "오류",
                   message: String,
                   primaryButtonTitle: String,
                   okButtonTitle: String = "확인",
                   primaryAction: @escaping (UIAlertAction) -> Void,
                   okAction: @escaping (UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.view.tintColor = CCDesign.Color.tintColor.color
        
        let primaryButton = UIAlertAction(title: primaryButtonTitle, style: .default, handler: primaryAction)
        let okButton = UIAlertAction(title: okButtonTitle, style: .destructive, handler: okAction)
        
        alert.addAction(okButton)
        alert.addAction(primaryButton)

        
        navigationController?.present(alert, animated: true)
    }
}
