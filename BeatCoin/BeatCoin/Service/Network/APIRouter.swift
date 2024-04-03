//
//  Router.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case trending
    case searchCoin(query: String)
    case coin(ids: [String])
    
    var baseURL: URL {
        URL(string: "https://api.coingecko.com/api/v3")!
    }
    
    var endPoint: URL {
        switch self {
        case .trending:
            baseURL.appendingPathComponent("/search/trending")
        case .searchCoin:
            baseURL.appendingPathComponent( "/search")
        case .coin:
            baseURL.appendingPathComponent("/coins/markets")
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
        let url = try endPoint.asURL()
        var request = URLRequest(url: url)
        request.method = method
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
