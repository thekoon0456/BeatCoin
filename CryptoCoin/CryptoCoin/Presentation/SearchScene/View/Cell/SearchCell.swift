//
//  SearchCell.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/28/24.
//

import UIKit

final class SearchCell: BaseTableViewCell {
    
    // MARK: - Properties
    
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
    
    private lazy var favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: CCDesign.Icon.star.name), for: .normal)
        $0.setImage(UIImage(named: CCDesign.Icon.starFill.name), for: .selected)
    }
    
    // MARK: - Helpers
    
    func configureCell(_ data: CoinEntity, isFavorite: Bool) {
        iconImageView.kf.setImage(with: URL(string: data.image))
        titleLabel.text = data.name
        subtitleLabel.text = data.symbol
        favoriteButton.isSelected = isFavorite
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        contentView.addSubviews(iconImageView,
                                titleLabel,
                                subtitleLabel,
                                favoriteButton)
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
        }
    }
}
