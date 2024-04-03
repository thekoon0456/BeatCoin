//
//  CoinConst.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import UIKit

enum CCConst {
    
    enum NaviTitle {
        case trending
        case search
        case favorite
        
        var name: String {
            switch self {
            case .trending:
                "Beat Coin"
            case .search:
                "Search"
            case .favorite:
                "Favorite Coin"
            }
        }
    }
    
    enum priceLabel {
        case highPrice
        case lowPrice
        case highestPrice
        case lowestPrice
        
        var name: String {
            switch self {
            case .highPrice:
                "고가"
            case .lowPrice:
                "저가"
            case .highestPrice:
                "신고점"
            case .lowestPrice:
                "신저점"
            }
        }
    }
    
    enum Ments {
        case searchPlaceHolder
        case moreSee
        case dismiss
        case retry
        
        var text: String {
            switch self {
            case .searchPlaceHolder:
                "Search Coin"
            case .moreSee:
                "더 보기"
            case .dismiss:
                "되돌아가기"
            case .retry:
                "다시 시도하기"
            }
        }
    }
}

enum CCLayout {
    case width
    case height
    
    var value: CGFloat {
        switch self {
        case .width:
            UIScreen.main.bounds.width
        case .height:
            UIScreen.main.bounds.height
        }
    }
}
