//
//  SearchCell.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/28/24.
//

import UIKit

import Kingfisher

final class SearchCell: BaseTableViewCell {
    
    // MARK: - Properties
    
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
    
    lazy var favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: CCDesign.Icon.star.name), for: .normal)
        $0.setImage(UIImage(named: CCDesign.Icon.starFill.name), for: .selected)
    }
    
    // MARK: - Helpers
    
    func configureCell(_ data: CoinEntity, keyword: String?, isFavorite: Bool, tag: Int) {
        iconImageView.kf.setImage(with: URL(string: data.image))
        titleLabel.attributedText = setAttributedText(data.name, pointText: keyword)
        subtitleLabel.text = data.symbol
        favoriteButton.tag = tag
        favoriteButton.isSelected = isFavorite
    }
    
    func setAttributedText(_ inputText: String, pointText: String?) -> NSAttributedString {
        let lowercasedInputText = inputText.lowercased()
        let lowercasedPointText = pointText?.lowercased() ?? ""
        let attributedString = NSMutableAttributedString(string: inputText)
        attributedString.addAttribute(.foregroundColor,
                                      value: CCDesign.Color.tintColor.color,
                                      range: (lowercasedInputText as NSString).range(of: lowercasedPointText))
        return attributedString
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
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
        }
    }
}
