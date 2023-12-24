//
//  CurrencyConverter.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 21.12.2023.
//

import Foundation

// MARK: - CurrencyConverter - струкрутра для извлечения данных из интернета 

struct CurrencyConverter: Decodable {
    let disclaimer: String
    let date: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}
