//
//  CoinConst.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

enum CCConst {
    
}

enum CCDesign {
    
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
