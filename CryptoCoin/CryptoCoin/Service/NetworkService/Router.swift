//
//  Router.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import Alamofire

enum Router {
    case trending
    case searchCoin(query: String)
    case coin(ids: [String])
    
    var baseURL: String {
        "https://api.coingecko.com/api/v3"
    }
    
    var endPoint: URL {
        switch self {
        case .trending:
            URL(string: baseURL + "/search/trending")!
        case .searchCoin:
            URL(string: baseURL + "/search")!
        case .coin:
            URL(string: baseURL + "/coins/markets")!
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameter: Parameters {
        switch self {
        case .trending:
            [:]
        case .searchCoin(let query):
            ["query": query]
        case .coin(let ids):
            [
                "vs_currency": "krw",
                "ids": ids,
                "sparkline": true
            ]
        }
    }
}
