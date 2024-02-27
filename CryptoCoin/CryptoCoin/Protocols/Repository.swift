//
//  Repository.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

protocol Repository {
    associatedtype T = Entity
    
    func fetch(router: Router, completionHandler: @escaping ((T) -> Void))
}
