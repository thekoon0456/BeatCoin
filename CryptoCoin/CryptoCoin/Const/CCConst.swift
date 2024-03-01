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
                "Crypto Coin"
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
