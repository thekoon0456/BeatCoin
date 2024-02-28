//
//  ChartViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

import Charts
import Kingfisher
import SnapKit

final class ChartViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel = ChartViewModel()
    
    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = CCDesign.Font.big.font
    }
    
    private let mainPriceLabel = UILabel().then {
        $0.font = CCDesign.Font.big.font
    }
    
    private let percentLabel = UILabel().then {
        $0.font = CCDesign.Font.price.font
    }
    
    private let dateLabel = UILabel().then {
        $0.font = CCDesign.Font.price.font
        $0.textColor = CCDesign.Color.gray.color
        $0.text = "Today"
    }
    
    private let updateLabel = UILabel().then {
        $0.font = CCDesign.Font.percent.font
        $0.textColor = CCDesign.Color.gray.color
        $0.text = "Today"
    }
    
    private lazy var favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: CCDesign.Icon.star.name), for: .normal)
        $0.setImage(UIImage(named: CCDesign.Icon.starFill.name), for: .selected)
        $0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private let highPriceView = ChartPriceView(title: "고가",
                                               color: CCDesign.Color.highPrice.color)
    private let highestPriceView = ChartPriceView(title: "신고점",
                                                  color: CCDesign.Color.highPrice.color)
    private let lowPriceView = ChartPriceView(title: "저가",
                                              color: CCDesign.Color.lowPrice.color)
    private let lowestPriceView = ChartPriceView(title: "신저점",
                                                 color: CCDesign.Color.lowPrice.color)
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputCoinName.onNext("solana")
        bind()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    // MARK: - Selectors
    
     @objc private func favoriteButtonTapped() {
         print("눌림")
         viewModel.inputFavorite.onNext((viewModel.outputCoinData.currentValue.first?.id))
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.outputCoinData.bind { [weak self] coin in
            guard let self,
                  let coin = coin.first
            else { return }
            print(coin)
            setData(coin)
        }
        
        viewModel.outputFavorite.bind { [weak self] bool in
            guard let self,
                  let bool else { return }
            print(bool)
            favoriteButton.isSelected = bool
        }
    }
    
    // MARK: - Configure
    
    private func setData(_ data: CoinEntity) {
        iconImageView.kf.setImage(with: URL(string: data.image))
        titleLabel.text = data.name
        mainPriceLabel.text = data.currentPrice
        percentLabel.text = data.priceChangePercentage24H
        percentLabel.textColor = data.isUp
        ? CCDesign.Color.highPrice.color
        : CCDesign.Color.lowPrice.color
        highPriceView.configureLabel(price: data.high24h)
        highestPriceView.configureLabel(price: data.ath)
        lowPriceView.configureLabel(price: data.low24h)
        lowestPriceView.configureLabel(price: data.atl)
        updateLabel.text = data.lastUpdated
    }
    
    override func configureHierarchy() {
        view.addSubviews(iconImageView,
                         titleLabel,
                         mainPriceLabel,
                         percentLabel,
                         dateLabel,
                         highPriceView,
                         highestPriceView,
                         lowPriceView,
                         lowestPriceView,
                         updateLabel)
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
    
        mainPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.top.equalTo(mainPriceLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(percentLabel.snp.top)
            make.leading.equalTo(percentLabel.snp.trailing).offset(4)
        }
        
        highPriceView.snp.makeConstraints { make in
            make.top.equalTo(percentLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(highPriceView.snp.width).dividedBy(3)
        }
        
        lowPriceView.snp.makeConstraints { make in
            make.top.equalTo(highPriceView.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(lowPriceView.snp.width).dividedBy(3)
        }
        
        highestPriceView.snp.makeConstraints { make in
            make.top.equalTo(highPriceView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(highestPriceView.snp.width).dividedBy(3)
        }
        
        lowestPriceView.snp.makeConstraints { make in
            make.top.equalTo(lowPriceView.snp.bottom).offset(20)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(lowestPriceView.snp.width).dividedBy(3)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
