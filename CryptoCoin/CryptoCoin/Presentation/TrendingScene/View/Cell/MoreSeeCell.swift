//
//  MoreSeeCell.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/3/24.
//

import UIKit

import SnapKit

final class MoreSeeCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel().then {
        $0.font = CCDesign.Font.titleBold.font
        $0.text = "더 보기"
    }

    // MARK: - Configure
    
    override func configureHierarchy() {
        contentView.addSubviews(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = CCDesign.Color.lightGray.color
        contentView.layer.cornerRadius = 12
    }
}
