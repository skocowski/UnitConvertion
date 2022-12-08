//
//  Favourites.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 18/09/2022.
//

import SwiftUI

class Favourites: ObservableObject, Codable {
    // Currencies marked as favourities
    private var currencies: Set<String>
    
    // The UserDefaults key
    private let saveKey = "Favourities"
    
    init() {
        // Load saved data
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                currencies = decoded
                return
            }
        }
        
        // If there is no saved data
        currencies = []
    }
    
    // Checking if contains favourited
    func contains(_ currency: NewCurrency) -> Bool {
        currencies.contains(currency.name)
    }
    
    // Adding to favourities
    func add(_ currency: NewCurrency) {
        objectWillChange.send()
        currencies.insert(currency.name)
        save()
    }
    
    // Removing from favourities
    func remove(_ currency: NewCurrency) {
        objectWillChange.send()
        currencies.remove(currency.name)
        save()
    }
    
    // Saving favourite curriencies into UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(currencies) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
