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
                UIColor(hex: "914CF5")
            case .highPrice:
                UIColor(hex: "F04452")
            case .highPriceBC:
                UIColor(hex: "FFFAED")
            case .lowPrice:
                UIColor(hex: "3282F8")
            case .lowPriceBC:
                UIColor(hex: "E5F0FF")
            case .black:
                UIColor(hex: "000000")
            case .gray:
                UIColor(hex: "828282")
            case .label:
                UIColor(hex: "343D4C")
            case .lightGray:
                UIColor(hex: "F3F4F6")
            case .white:
                UIColor(hex: "FFFFFF")
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
