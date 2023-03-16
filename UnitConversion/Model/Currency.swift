//
//  Currency.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 08/09/2022.
//

import Foundation

// Struct matching the API
struct Currency: Codable, Hashable {
    var success: Bool
    var base: String
    var date: String
    var rates = [String: Double]()
}

// New struct to match the project needs
struct AdjustedCurrency {
    var name: String
    var rate: String
}




