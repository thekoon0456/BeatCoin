//
//  SearchCoin.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

// MARK: - SearchDTO
struct SearchDTO: Decodable {
    let coins: [SearchCoin]
    let exchanges: [Exchange]
    let icos: [String?]
    let categories: [SearchCategory]
    let nfts: [SearchNft]
}

// MARK: - Category
struct SearchCategory: Decodable {
    let id: Int
    let name: String
}

// MARK: - Coin
struct SearchCoin: Decodable {
    let id, name, apiSymbol, symbol: String
    let marketCapRank: Int?
    let thumb, large: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case apiSymbol = "api_symbol"
        case symbol
        case marketCapRank = "market_cap_rank"
        case thumb, large
    }
}

// MARK: - Exchange
struct Exchange: Decodable {
    let id, name, marketType: String
    let thumb, large: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case marketType = "market_type"
        case thumb, large
    }
}

// MARK: - Nft
struct SearchNft: Decodable {
    let id, name, symbol: String
    let thumb: String
}

//struct SearchCoin: Decodable {
//    let id: String //"bitcoin"
//    let name: String //"Bitcoin"
//    let api_symbol: String //"bitcoin"
//    let symbol: String //"BTC"
//    let thumb: String //"https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png"
//}
