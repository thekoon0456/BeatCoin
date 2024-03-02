//
//  UIViewController+.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/29/24.
//

import UIKit

extension Coordinator {
    
    func showAlert(title: String = "오류가 발생했어요",
                   message: String,
                   primaryButtonTitle: String,
                   okButtonTitle: String = "확인",
                   primaryAction: (() -> Void)?,
                   okAction: (() -> Void)?) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.view.tintColor = CCDesign.Color.tintColor.color
        
        let primaryButton = UIAlertAction(title: primaryButtonTitle, style: .default) { _ in
            primaryAction?()
        }
        
        let okButton = UIAlertAction(title: okButtonTitle, style: .destructive) { _ in
            okAction?()
        }
        
        alert.addAction(okButton)
        alert.addAction(primaryButton)
        
        navigationController?.present(alert, animated: true)
    }
    
    func showToast(_ type: Toast) {
        let vc = ToastViewController(inputMessage: type.message)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            vc.dismiss(animated: true)
        }
    }
}
