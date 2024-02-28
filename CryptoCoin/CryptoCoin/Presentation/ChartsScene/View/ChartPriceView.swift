//
//  ChartPriceView.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/28/24.
//

import UIKit

final class ChartPriceView: BaseView {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel().then {
        $0.font = CCDesign.Font.priceBold.font
    }
    
    private let priceLabel = UILabel().then {
        $0.font = CCDesign.Font.priceBold.font
        $0.textColor = CCDesign.Color.label.color
    }
    
    init(title: String, color: UIColor) {
        titleLabel.text = title
        titleLabel.textColor = color
        super.init(frame: .zero)
    }
    
    // MARK: - Helpers
    
    func configureLabel(price: String) {
        priceLabel.text = price
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        addSubviews(titleLabel, priceLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    override func configureView() {
        
    }
}
