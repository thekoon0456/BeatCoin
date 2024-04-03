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
                   okButtonTitle: String = "확인",
                   primaryButtonTitle: String,
                   okAction: (() -> Void)? = nil,
                   primaryAction: (() -> Void)?) {
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
        
        // MARK: - 통신 안됐을때 흰색으로 배경 가림
        
        let bgView = UIView().then {
            $0.backgroundColor = .white
        }
        navigationController?.topViewController?.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
