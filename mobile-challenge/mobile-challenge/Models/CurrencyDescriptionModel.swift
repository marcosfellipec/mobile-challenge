//
//  CurrencyModel.swift
//  mobile-challenge
//
//  Created by Marcos Fellipe Costa Silva on 24/04/21.
//

import Foundation

public struct CurrencyNameModel: Codable {
    public var currencies: [CurrencyDescription]
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let currencies = try values.decode([String: String].self, forKey: .currencies)
        
        self.currencies = currencies.compactMap { CurrencyDescription(key: $0.key, name: $0.value)}
    }
}

public struct CurrencyDescription: Codable {
    public var key: String = ""
    public var name: String = ""
}
