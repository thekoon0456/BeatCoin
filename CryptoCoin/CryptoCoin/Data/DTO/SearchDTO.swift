//
//  SearchCoin.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

// MARK: - SearchDTO
struct SearchDTO: DTO {
    let coins: [SearchCoin]
    let exchanges: [Exchange]
    let icos: [String?]
    let categories: [SearchCategory]
    let nfts: [SearchNft]
}

// MARK: - Category
struct SearchCategory: DTO {
    let id: Int
    let name: String
}

// MARK: - Coin
struct SearchCoin: DTO {
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
    
    var toEntity: CoinEntity {
        return CoinEntity(id: id,
                          name: name,
                          symbol: symbol,
                          image: thumb,
                          currentPrice: "",
                          priceChangePercentage24H: "",
                          isUp: false,
                          high24h: "",
                          low24h: "",
                          ath: "",
                          atl: "",
                          lastUpdated: nil,
                          sparklineIn7D: [],
                          score: nil,
                          price: nil)
    }
}

// MARK: - Exchange
struct Exchange: DTO {
    let id, name, marketType: String
    let thumb, large: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case marketType = "market_type"
        case thumb, large
    }
}

// MARK: - Nft
struct SearchNft: DTO {
    let id, name, symbol: String
    let thumb: String
}
