//
//  Toast.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/29/24.
//

import UIKit

enum Toast {
    case setFavorite(coin: String)
    case deleteFavorite(coin: String)
    
    var message: String {
        switch self {
        case .setFavorite(let coin):
            coin + "이 즐겨찾기에 추가되었습니다."
        case .deleteFavorite(let coin):
            coin + "이 즐겨찾기에 해제되었습니다."
        }
    }
}

final class ToastViewController: BaseViewController {
    
    // MARK: - Properties
    
    let inputMessage: Toast
    
    private let messageLabel = PaddingLabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.padding = .init(top: 12, left: 12, bottom: 12, right: 12)
        $0.backgroundColor = CCDesign.Color.tintColor.color
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    // MARK: - Helpers
    
    init(inputMessage: Toast) {
        self.inputMessage = inputMessage
        super.init()
    }
    
    // MARK: - Helpers
    
    override func configureHierarchy() {
        view.addSubview(messageLabel)
    }
    
    override func configureLayout() {
        messageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .clear
        messageLabel.text = inputMessage.message
    }
}

final class PaddingLabel: UILabel {
    
    var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
