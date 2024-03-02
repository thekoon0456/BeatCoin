//
//  CCError.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/29/24.
//

import Foundation

enum CCError: Int, CaseIterable, Error {
    case badRequest = 400
    case Unauthorised = 401
    case tooManyRequests = 429
    case serviceUnavailable = 503
    case internalServerError = 500
    case apiKeyMissing = 10002
    case notEndPoint = 0005
    case forbidden = 403
    case accessDenied = 1020
    case unKnown
    
    var description: String {
        switch self {
        case .badRequest:
            "유효하지 않은 요청입니다. 재시도 해주세요."
        case .Unauthorised:
            "승인되지 않은 계정입니다. 계정을 확인해주세요."
        case .tooManyRequests:
            "요청이 너무 많습니다. 잠시 후 재시도 해주세요."
        case .serviceUnavailable:
            "현재 이용할 수 없는 서비스입니다. 다른 기능을 사용해주세요."
        case .internalServerError:
            "내부 서버 오류입니다. 잠시 후 재시도 해주세요."
        case .apiKeyMissing:
            "api키가 누락되어있습니다. 확인해주세요."
        case .notEndPoint:
            "제한된 엔드포인트입니다. 계정을 확인해주세요."
        case .forbidden:
            "차단된 사용자입니다. 앱을 꺼주세요."
        case .accessDenied:
            "방화벽 접근 거부되었습니다. 확인해주세요."
        case .unKnown:
            "네트워크 오류입니다. 네트워크 연결을 확인해주세요."
        }
    }
}
