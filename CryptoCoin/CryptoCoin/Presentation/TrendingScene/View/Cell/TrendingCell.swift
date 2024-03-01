//
//  TrendingCell.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/29/24.
//

import UIKit

import Kingfisher

final class TrendingCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let rankLabel = UILabel().then {
        $0.font = CCDesign.Font.rank.font
    }
    
    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = CCDesign.Font.titleBold.font
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = CCDesign.Font.subtitle.font
        $0.textColor = CCDesign.Color.gray.color
    }
    
    private let priceLabel = UILabel().then {
        $0.font = CCDesign.Font.titleBold.font
    }
    
    private let persentLabel = UILabel().then {
        $0.font = CCDesign.Font.subtitle.font
    }
    
    lazy var favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: CCDesign.Icon.star.name), for: .normal)
        $0.setImage(UIImage(named: CCDesign.Icon.starFill.name), for: .selected)
    }
    
    // MARK: - Helpers
    
    func configureCell(_ data: CoinEntity) {
        rankLabel.text = String((data.score ?? 0) + 1)
        iconImageView.kf.setImage(with: URL(string: data.image))
        titleLabel.text = data.name
        subtitleLabel.text = data.symbol
        priceLabel.text = data.currentPrice
        persentLabel.text = data.priceChangePercentage24H
        persentLabel.textColor = data.isUp
        ? CCDesign.Color.highPrice.color
        : CCDesign.Color.lowPrice.color
    }
    
    func configureNFTCell(_ data: NFTEntity, index: Int) {
        rankLabel.text = String(index + 1)
        iconImageView.kf.setImage(with: URL(string: data.thumb))
        titleLabel.text = data.name
        subtitleLabel.text = data.symbol
        priceLabel.text = data.floorPrice
        persentLabel.text = data.floorPrice24hPercentageChange
        persentLabel.textColor = data.isUp
        ? CCDesign.Color.highPrice.color
        : CCDesign.Color.lowPrice.color
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        contentView.addSubviews(rankLabel,
                                iconImageView,
                                titleLabel,
                                subtitleLabel,
                                priceLabel,
                                persentLabel)
    }
    
    override func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalTo(rankLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-4)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(persentLabel.snp.leading).offset(-4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        persentLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
}
