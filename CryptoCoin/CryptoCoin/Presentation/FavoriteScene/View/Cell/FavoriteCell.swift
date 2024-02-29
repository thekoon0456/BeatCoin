//
//  FavoriteCell.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/28/24.
//

import UIKit

import Kingfisher
import SnapKit

final class FavoriteCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }

    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
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
    
    private let percentBG = UIView().then {
        $0.backgroundColor = CCDesign.Color.highPriceBC.color
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
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
        percentBG.backgroundColor = data.isUp
        ? CCDesign.Color.highPriceBC.color
        : CCDesign.Color.lowPriceBC.color
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        contentView.addSubview(backView)
        backView.addSubviews(iconImageView,
                             titleLabel,
                             subtitleLabel,
                             priceLabel,
                             percentBG)
        
        percentBG.addSubview(percentLabel)
    }
    
    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(percentBG.snp.top).offset(-4)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        percentBG.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-20)
        }
    }
    
    override func configureView() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .init(width: 0, height: 0)
        layer.shadowColor = CCDesign.Color.lightGray.color.cgColor
        layer.shadowRadius = 5
    }
}

