//
//  NumberFormatter.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/28/24.
//

import Foundation

final class NumberFormatterService {
    
    static let shared = NumberFormatterService()
    
    private init() { }
    
    //가격에 콤마 넣기
    func toCurruncy(price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        let result = numberFormatter.string(from: NSNumber(value: price)) ?? ""
        return "₩" + result
    }
}
