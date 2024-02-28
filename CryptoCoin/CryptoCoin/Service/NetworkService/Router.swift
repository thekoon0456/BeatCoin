//
//  Router.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import Alamofire

enum Router: URLRequestConvertible {
    
    case trending
    case searchCoin(query: String)
    case coin(ids: [String])
    
    var baseURL: String {
        "https://api.coingecko.com/api/v3"
    }
    
    var endPoint: String {
        switch self {
        case .trending:
            "/search/trending"
        case .searchCoin:
            "/search"
        case .coin:
            "/coins/markets"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters {
        switch self {
        case .trending:
            [:]
        case .searchCoin(let query):
            ["query": query]
        case .coin(let ids):
            ["vs_currency": "krw",
             "ids": ids.joined(separator: ","),
             "sparkline": "true"]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
