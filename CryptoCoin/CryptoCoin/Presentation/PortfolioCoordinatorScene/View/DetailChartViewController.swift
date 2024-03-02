//
//  DetailChartViewController.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

import DGCharts
import Kingfisher
import SnapKit

final class DetailChartViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: DetailChartViewModel
    private lazy var chartView = LineChartView().then {
        $0.rightAxis.enabled = false
        $0.leftAxis.enabled = false
        $0.xAxis.enabled = false
        $0.dragEnabled = false
        $0.legend.enabled = false
        $0.setVisibleXRangeMinimum(1)
    }
    
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
    }
    
    private lazy var favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: CCDesign.Icon.star.name), for: .normal)
        $0.setImage(UIImage(named: CCDesign.Icon.starFill.name), for: .selected)
        $0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private let highPriceView = ChartPriceView(title: CCConst.priceLabel.highPrice.name,
                                               color: CCDesign.Color.highPrice.color)
    private let highestPriceView = ChartPriceView(title: CCConst.priceLabel.highestPrice.name,
                                                  color: CCDesign.Color.highPrice.color)
    private let lowPriceView = ChartPriceView(title: CCConst.priceLabel.lowPrice.name,
                                              color: CCDesign.Color.lowPrice.color)
    private let lowestPriceView = ChartPriceView(title: CCConst.priceLabel.lowestPrice.name,
                                                 color: CCDesign.Color.lowPrice.color)
    
    // MARK: - Lifecycles
    
    init(viewModel: DetailChartViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.inputViewDidLoad.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Selectors
    
    @objc private func favoriteButtonTapped() {
        guard let id = viewModel.outputCoinData.currentValue.first?.id else { return }
        viewModel.inputFavorite.onNext(id)
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.outputCoinData.bind { [weak self] coin in
            guard let self,
                  let coin = coin.first
            else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                setData(coin)
            }
        }
        
        viewModel.outputFavorite.bind { [weak self] bool in
            guard let self,
                  let bool else { return }
            favoriteButton.isSelected = bool
        }
        
        viewModel.outputError.bind { [weak self] error in
            guard let self,
                  let error
            else { return }
            
            if error == .maxFavorite {
                setMaxToast()
            }
            
            showAlert(message: error.description,
                      primaryButtonTitle: "재시도하기",
                      okButtonTitle: "취소") { [weak self] _ in
                guard let self else { return }
                viewModel.inputViewDidLoad.onNext(())
                dismiss(animated: true)
            } okAction: { [weak self] _ in
                guard let self else { return }
                dismiss(animated: true)
            }
        }
    }
    
    private func setMaxToast() {
        let vc = ToastViewController(inputMessage: .maxFavorite)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            vc.dismiss(animated: true)
        }
    }
    
    // MARK: - Configure
    
    // Chart 데이터 적용하기
    func setLineData(lineChartView: LineChartView, lineChartDataEntries: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: lineChartDataEntries)
        //gradient 설정
        set.gradientPositions = [0, 1]
        let gradientColors = [CCDesign.Color.white.color.cgColor,
                              CCDesign.Color.tintColor.color.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set.fillAlpha = 1
        set.fill = LinearGradientFill(gradient: gradient, angle: 90)
        set.drawFilledEnabled = true
        set.colors = [CCDesign.Color.tintColor.color]
        set.mode = .cubicBezier
        //점 설정
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        let lineChartData = LineChartData(dataSet: set)
        lineChartView.data = lineChartData
    }
    
    // Chart entry 만들기
    func entryData(values: [Double]) -> [ChartDataEntry] {
        var lineDataEntries: [ChartDataEntry] = []
        for i in 0 ..< values.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntries.append(lineDataEntry)
        }
        return lineDataEntries
    }
    
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
        setLineData(lineChartView: chartView, lineChartDataEntries: entryData(values: data.sparklineIn7D))
    }
    
    // MARK: - Configure
    
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
                         chartView,
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
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
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
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(highestPriceView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        updateLabel.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = .none
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
}
