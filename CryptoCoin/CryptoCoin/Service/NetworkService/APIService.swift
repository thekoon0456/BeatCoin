//
//  APIService.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

import Alamofire

final class APIService {
    
    static let shared = APIService()
    
    private init() { }
    
    func callRequest<T: Decodable>(api: Router, type: T.Type = T.self, completionHandler: @escaping ((T) -> Void)) {
        AF
            .request(api.endPoint,
                     method: api.method,
                     parameters: api.parameter)
            .validate(statusCode: 200...299)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let failure):
                    print(failure)
                }
            }
    }
}
