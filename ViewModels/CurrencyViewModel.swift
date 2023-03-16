//
//  CurrencyViewModel.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 16/3/23.
//

import Foundation

@MainActor
class CurrencyViewModel: ObservableObject {
    
    
    
    @Published var input: Double?
    @Published var base: String = "\(Locale.current.currency?.identifier ?? "USD")"
    @Published var currencyList = [String]()
    @Published var currencyArray = [AdjustedCurrency]()
    @Published var searchText = ""
    @Published var showFavourites = false
    @Published var presentPicker = false
    @Published var isLoading = false
    
    
//    var favouritesCurrencies: [AdjustedCurrency] {
//        if showFavourites {
//            return currencyArray.filter { favourities.contains($0) }
//        } else {
//            return currencyArray
//        }
//    }
    
    var filteredCurrencies: [String] {
        if searchText.isEmpty {
            return currencyList
        } else {
            return currencyList.filter { $0.lowercased().contains(searchText.lowercased())}
        }
    }
    // Downloading JSON from API
    func getJSON<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: urlString) else {
            isLoading = false
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
    
    func makeRequest() async {
        isLoading = true
        getJSON(urlString: "https://api.exchangerate.host/latest?base=\(base)&amount=\(input ?? 1)") { (currency: Currency?) in
            var tempList = [String]()
            var tempArray = [AdjustedCurrency]()
            DispatchQueue.main.async {
                if let currency = currency {
                    for currency in currency.rates {
                        tempList.append("\(currency.key)")
                        
                        var formattedRate: String {
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .decimal
                            formatter.maximumFractionDigits = 2
                            formatter.minimumFractionDigits = 2
                            formatter.decimalSeparator = "."
                            formatter.groupingSeparator = " "
                            
                            return formatter.string(from: currency.value as NSNumber) ?? ""
                        }
                        tempArray.append(AdjustedCurrency(name: currency.key, rate: formattedRate))
                    }
                }
                
                tempList.sort()
                tempArray.sort { (lhs: AdjustedCurrency, rhs: AdjustedCurrency) -> Bool in
                    return lhs.name < rhs.name
                }
                self.currencyList = tempList
                self.currencyArray = tempArray
                self.isLoading = false
            }
            
        }
    }
    
    func getFlag(currency: String) -> String {
        let base = 127397
        let currencyExceptions: [String] = ["ANG", "XAF", "XAG", "XAU", "XCD", "XDR", "XOF", "XPD", "XPF", "XPT", "BTC"]
        
        if currencyExceptions.contains(currency) {
            return ""
        }
        
        var code = currency
        code.removeLast()
        var scalar = String.UnicodeScalarView()
        
        for i in code.utf16 {
            scalar.append(UnicodeScalar(base + Int(i))!)
        }
        return String(scalar)
    }
}


