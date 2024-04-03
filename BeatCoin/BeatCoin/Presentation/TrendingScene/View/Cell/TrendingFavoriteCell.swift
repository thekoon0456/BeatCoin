//
//  TrendingFavoriteCell.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/29/24.
//

import UIKit

import Kingfisher
import SnapKit

final class TrendingFavoriteCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let titleLabel = UILabel().then {
        $0.font = CCDesign.Font.titleBold.font
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = CCDesign.Font.subtitle.font
        $0.textColor = CCDesign.Color.gray.color
    }
    
    private let priceLabel = UILabel().then {
        $0.font = CCDesign.Font.priceBold.font
    }
    
    private let percentLabel = UILabel().then {
        $0.font = CCDesign.Font.percentBold.font
    }
    
    // MARK: - Helpers
    
    func configureCell(_ data: CoinEntity) {
        iconImageView.kf.setImage(with: URL(string: data.image))
        titleLabel.text = data.name
        subtitleLabel.text = data.symbol
        priceLabel.text = data.currentPrice
        percentLabel.text = data.priceChangePercentage24H
        percentLabel.textColor = data.isUp
        ? CCDesign.Color.highPrice.color
        : CCDesign.Color.lowPrice.color
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        contentView.addSubviews(iconImageView,
                                titleLabel,
                                subtitleLabel,
                                priceLabel,
                                percentLabel)
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalTo(percentLabel.snp.top).offset(-4)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = CCDesign.Color.lightGray.color
        contentView.layer.cornerRadius = 12
    }
}


