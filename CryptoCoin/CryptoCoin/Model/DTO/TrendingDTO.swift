//
//  TrendingEntity.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

/*
 id id
 이름 name
 아이콘
 약어
 현재가
 오르내림
*/

// MARK: - TrendingDTO
struct TrendingDTO: Decodable {
    let coins: [Coin]
    let nfts: [Nft]
    let categories: [Category]
}

// MARK: - Category
struct Category: Decodable {
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
struct CategoryData: Decodable {
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
struct Coin: Decodable {
    let item: Item
}

// MARK: - Item
struct Item: Decodable {
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
struct ItemData: Decodable {
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
struct Content: Decodable {
    let title, description: String
}

// MARK: - Nft
struct Nft: Decodable {
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
}

// MARK: - NftData
struct NftData: Decodable {
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






//
//struct Trending: Decodable {
//    let coins: [TrendingCoin]
////    let categories: [TrendingNFT]
//}
//
//struct TrendingCoin: Decodable {
//    let id: String //"pyth-network"
//    let name: String //"Pyth Network"
//    let symbol: String //"PYTH"
//    let thumb: String //썸네일 URL "https://assets.coingecko.com/coins/images/31924/thumb/pyth.png?1701245725"
//    let score: Int //순위 (0부터)
//    let data: [TrendingCoinData]?
//}
//
//struct TrendingCoinData: Decodable {
//    let price: String //현재 가격 "$3.92"
//    let price_change_percentage_24H: [String: Double] //코인 변동폭 -> "kwd": 41.94207220207385
//}
//
//struct TrendingNFT: Decodable {
//    let id: Int //"pyth-network"
//    let name: String //"Pyth Network"
////    let symbol: String //"PYTH"
//    let floor_price_in_native_currency: Double //현재가격
//    let floor_price_24h_percentage_change: Double //등락여부 소수점 두자리까지
//    let data: TrendingNFTData
//}
//
//struct TrendingNFTData: Decodable {
//    let floor_price: String //"2.38 ETH"
//}
