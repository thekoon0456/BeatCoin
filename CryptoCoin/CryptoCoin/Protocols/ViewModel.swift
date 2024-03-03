//
//  ViewModel.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

protocol ViewModel {
    associatedtype T = Coordinator
    associatedtype Input
    associatedtype Output
    
    var coordinator: T { get }
    var input: Input { get }
    var output: Output { get }
}

extension ViewModel {
    
    func checkError(error: Error) -> CCError {
        guard let code = error.asAFError?.responseCode,
              let error = CCError(rawValue: code)
        else { return .unKnown }
        return error
    }
}
