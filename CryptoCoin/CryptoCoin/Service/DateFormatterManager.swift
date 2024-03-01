//
//  DateFormatterManager.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/28/24.
//

import Foundation

final class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    
    private init() { }
    
    let formatter = DateFormatter()
    private var krLocale = Locale(identifier: "ko_kr")
    
    // MARK: - 최종적인 format결과
    
    func formattedDate(input: String, inputFormat: DateStyle = .input, outputFormat: DateStyle = .update) -> String? {
        let date = stringToDate(input, format: inputFormat)
        return dateToString(date, format: outputFormat)
    }
    
    func dateToString(_ date: Date?, format: DateStyle) -> String? {
        formatter.locale = krLocale
        formatter.dateFormat = format.rawValue
        guard let date else { return nil }
        let result = formatter.string(from: date)
        return result
    }
    
    func stringToDate(_ stringDate: String, format: DateStyle) -> Date? {
        formatter.locale = krLocale
        formatter.dateFormat = format.rawValue
        let result = formatter.date(from: stringDate)
        return result
    }
}

// MARK: - DateStyle

extension DateFormatterManager {
    
    enum DateStyle: String {
        case input = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case update = "M/d hh:mm:ss 업데이트"
    }
}
