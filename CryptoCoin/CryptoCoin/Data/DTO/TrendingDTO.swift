//
//  TrendingEntity.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

// MARK: - TrendingDTO
struct TrendingDTO: DTO {
    let coins: [Coin]
    let nfts: [Nft]
    let categories: [Category]
    
    var toEntity: TrendingEntity {
        let coins = self.coins.map { $0.toEntity }
        let nfts = self.nfts.map { $0.toEntity }
        return TrendingEntity(coins: coins, nfts: nfts)
    }
}

// MARK: - Category
struct Category: DTO {
    let id: Int
    let name: String
    let marketCap1HChange: Double
    let slug: String
    let coinsCount: Int
    let data: CategoryData
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case marketCap1HChange = "market_cap_1h_change"
        case slug
        case coinsCount = "coins_count"
        case data
    }
}

// MARK: - CategoryData
struct CategoryData: DTO {
    let marketCap, marketCapBtc, totalVolume, totalVolumeBtc: Double
    let marketCapChangePercentage24H: [String: Double]
    let sparkline: String
    
    enum CodingKeys: String, CodingKey {
        case marketCap = "market_cap"
        case marketCapBtc = "market_cap_btc"
        case totalVolume = "total_volume"
        case totalVolumeBtc = "total_volume_btc"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case sparkline
    }
}

// MARK: - Coin
struct Coin: DTO {
    let item: Item
    
    var toEntity: CoinEntity {
        return CoinEntity(id: item.id,
                          name: item.name,
                          symbol: item.symbol,
                          image: item.thumb,
                          currentPrice: item.data.price,
                          priceChangePercentage24H:
                            String(format: "%.2f", item.data.priceChangePercentage24H["krw"] ?? 0) + "%"
                          ,
                          isUp: item.data.priceChangePercentage24H["krw"] ?? 0 > 0 ? true : false,
                          high24h: "",
                          low24h: "",
                          ath: "",
                          atl: "",
                          lastUpdated: nil,
                          sparklineIn7D: [],
                          score: item.score,
                          price: item.data.price)
    }
}

// MARK: - Item
struct Item: DTO {
    let id: String
    let coinID: Int
    let name, symbol: String
    let marketCapRank: Int
    let thumb, small, large: String
    let slug: String
    let priceBtc: Double
    let score: Int
    let data: ItemData
    
    enum CodingKeys: String, CodingKey {
        case id
        case coinID = "coin_id"
        case name, symbol
        case marketCapRank = "market_cap_rank"
        case thumb, small, large, slug
        case priceBtc = "price_btc"
        case score, data
    }
}

// MARK: - ItemData
struct ItemData: DTO {
    let price, priceBtc: String
    let priceChangePercentage24H: [String: Double]
    let marketCap, marketCapBtc, totalVolume, totalVolumeBtc: String
    let sparkline: String
    let content: Content?
    
    enum CodingKeys: String, CodingKey {
        case price
        case priceBtc = "price_btc"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCap = "market_cap"
        case marketCapBtc = "market_cap_btc"
        case totalVolume = "total_volume"
        case totalVolumeBtc = "total_volume_btc"
        case sparkline, content
    }
}

// MARK: - Content
struct Content: DTO {
    let title, description: String
}

// MARK: - Nft
struct Nft: DTO {
    let id, name, symbol: String
    let thumb: String
    let nftContractID: Int
    let nativeCurrencySymbol: String
    let floorPriceInNativeCurrency, floorPrice24HPercentageChange: Double
    let data: NftData
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, thumb
        case nftContractID = "nft_contract_id"
        case nativeCurrencySymbol = "native_currency_symbol"
        case floorPriceInNativeCurrency = "floor_price_in_native_currency"
        case floorPrice24HPercentageChange = "floor_price_24h_percentage_change"
        case data
    }
    
    var toEntity: NFTEntity {
        return NFTEntity(id: id,
                         name: name,
                         symbol: symbol,
                         thumb: thumb,
                         floorPrice: data.floorPrice,
                         floorPrice24hPercentageChange: floorPrice24HPercentageChange)
    }
    
}

// MARK: - NftData
struct NftData: DTO {
    let floorPrice, floorPriceInUsd24HPercentageChange, h24Volume, h24AverageSalePrice: String
    let sparkline: String
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case floorPrice = "floor_price"
        case floorPriceInUsd24HPercentageChange = "floor_price_in_usd_24h_percentage_change"
        case h24Volume = "h24_volume"
        case h24AverageSalePrice = "h24_average_sale_price"
        case sparkline, content
    }
}
