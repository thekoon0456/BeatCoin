//
//  Then.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 2/27/24.
//

import Foundation

extension NSObject: Then {}
protocol Then {}

extension Then where Self: AnyObject {
    func then(_ configure: (Self) -> Void) -> Self {
        configure(self)
        return self
    }
}
