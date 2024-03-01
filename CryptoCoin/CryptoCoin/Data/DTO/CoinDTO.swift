//
//  Coin.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

// MARK: - CoinDTO
struct CoinDTO: DTO {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank: Int?
    let fullyDilutedValuation: Int?
    let totalVolume, high24H, low24H: Double
    let priceChange24H: Double
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H, circulatingSupply, totalSupply, maxSupply: Double?
    let ath: Double
    let athChangePercentage: Double
    let athDate: String
    let atl: Double
    let atlChangePercentage: Double
    let atlDate: String
    let lastUpdated: String
    let sparklineIn7D: SparklineIn7D?

    var toEntity: CoinEntity {
        return CoinEntity(id: id,
                          name: name,
                          symbol: symbol.uppercased(),
                          image: image,
                          currentPrice: NumberFormatterManager.shared.toCurruncy(price: Int(currentPrice)),
                          priceChangePercentage24H:
                            String(format: "%.2f", priceChangePercentage24H ?? 0) + "%",
                          isUp: priceChangePercentage24H ?? 0 >= 0 ? true : false,
                          high24h: NumberFormatterManager.shared.toCurruncy(price: Int(high24H)),
                          low24h: NumberFormatterManager.shared.toCurruncy(price: Int(low24H)),
                          ath: NumberFormatterManager.shared.toCurruncy(price: Int(ath)),
                          atl: NumberFormatterManager.shared.toCurruncy(price: Int(atl)),
                          lastUpdated: DateFormatterManager.shared.formattedDate(input: lastUpdated),
                          sparklineIn7D: sparklineIn7D?.price ?? [],
                          score: nil,
                          price: nil)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
    }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: DTO {
    let price: [Double]
}
