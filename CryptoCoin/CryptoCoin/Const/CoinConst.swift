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
}

enum CCDesign {
    
    enum Color {
        case tintColor
        case highPrice
        case highPriceBC
        case lowPrice
        case lowPriceBC
        case black
        case gray
        case label
        case lightGray
        case white
        
        var color: UIColor {
            switch self {
            case .tintColor:
                UIColor(hexCode: "914CF5")
            case .highPrice:
                UIColor(hexCode: "F04452")
            case .highPriceBC:
                UIColor(hexCode: "FFFAED")
            case .lowPrice:
                UIColor(hexCode: "3282F8")
            case .lowPriceBC:
                UIColor(hexCode: "E5F0FF")
            case .black:
                UIColor(hexCode: "000000")
            case .gray:
                UIColor(hexCode: "828282")
            case .label:
                UIColor(hexCode: "343D4C")
            case .lightGray:
                UIColor(hexCode: "F3F4F6")
            case .white:
                UIColor(hexCode: "FFFFFF")
            }
        }
    }
    
    enum Icon {
        case star
        case starFill
        
        var name: String {
            switch self {
            case .star:
                "btn_star"
            case .starFill:
                "btn_star_fill"
            }
        }
    }
    
    enum TabIcon: CaseIterable {
        case trend
        case search
        case portfolio
        case user
        
        var name: String {
            switch self {
            case .trend:
                "tab_portfolio"
            case .search:
                "tab_search"
            case .portfolio:
                "tab_trend"
            case .user:
                "tab_user"
            }
        }
        
        var inactive: String {
            self.name + "_inactive"
        }
    }
}
