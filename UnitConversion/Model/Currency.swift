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
struct NewCurrency {
    var name: String
    var rate: String
}


// Downloading JSON from API
func getJSON<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) {
    guard let url = URL(string: urlString) else {
        return
    }
    
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print(error.localizedDescription)
            completion(nil)
            return
        }
        guard let data = data else {
            completion(nil)
            return
        }
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            completion(nil)
            return
        }
        completion(decodedData)
    }
    .resume()
}

