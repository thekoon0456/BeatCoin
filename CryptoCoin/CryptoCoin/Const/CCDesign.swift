//
//  CCDesign.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/1/24.
//

import UIKit

enum CCDesign {
    
    enum Font {
        case big
        case rank
        case titleBold
        case subtitle
        case priceBold
        case price
        case percentBold
        case percent
        
        var font: UIFont {
            switch self {
            case .big:
                    .boldSystemFont(ofSize: 28)
            case .rank:
                    .systemFont(ofSize: 24)
            case .titleBold:
                    .boldSystemFont(ofSize: 14)
            case .subtitle:
                    .systemFont(ofSize: 12)
            case .priceBold:
                    .boldSystemFont(ofSize: 14)
            case .price:
                    .systemFont(ofSize: 12)
            case .percentBold:
                    .boldSystemFont(ofSize: 12)
            case .percent:
                    .systemFont(ofSize: 12)
            }
        }
    }
    
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
//                UIColor(hex: "914CF5")
                UIColor.systemBlue
            case .highPrice:
                UIColor(hex: "F04452")
            case .highPriceBC:
                UIColor(hex: "FFEAED")
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
        case coin
        case icon
        
        var name: String {
            switch self {
            case .star:
                "star"
            case .starFill:
                "star.fill"
            case .coin:
                "bitcoinsign.circle"
            case .icon:
                "bitcoinsign.circle"
            }
        }
    }
    
    enum TabIcon: CaseIterable {
        case trending
        case search
        case portfolio
        case user
        
        var name: String {
            switch self {
            case .trending:
                "tab_trend"
            case .search:
                "tab_search"
            case .portfolio:
                "tab_portfolio"
            case .user:
                "tab_user"
            }
        }
        
        var inactive: String {
            self.name + "_inactive"
        }
    }
}


