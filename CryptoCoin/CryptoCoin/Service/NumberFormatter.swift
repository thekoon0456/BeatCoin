//
//  NumberFormatter.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/28/24.
//

import Foundation

final class NumberFormatterManager {
    
    static let shared = NumberFormatterManager()
    
    private init() { }
    
    //가격에 콤마 넣기
    func toCurruncy(price: Int) -> String {
        let numberFormatter = NumberFormatter() //NumberFormatter(): 숫자에 포맷팅을 도와주는 객체
        numberFormatter.numberStyle = .decimal //.decimal: 넘버 세자리 수마다 끊음
        numberFormatter.maximumFractionDigits = 0 //소수점 자리 필요없으니까 0으로
        let result = numberFormatter.string(from: NSNumber(value: price))! //(옵셔널 타입 String 타입으로 강제언래핑) //?? ""로 nil 인 경우에 빈 값 반환하는 방법도 있음.
        return "₩" + result
    }
    
}
