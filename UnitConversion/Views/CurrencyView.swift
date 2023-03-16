//
//  CurrencyView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 08/09/2022.
//
// https://api.exchangerate.host/latest?base=\(base)&amount=\(input)

import SwiftUI

struct CurrencyView: View {
    
    @StateObject var favourities = Favourites()
    
    @State private var input: Double?
    @State private var base: String = "\(Locale.current.currency?.identifier ?? "USD")"
    @State private var currencyList = [String]()
    @State private var currencyArray = [AdjustedCurrency]()
    @State private var searchText = ""
    
    @State private var showFavourites = false
    @State private var presentPicker = false
    @FocusState private var inputIsFocused: Bool
    
    private var filteredCurrencies: [String] {
        if searchText.isEmpty {
            return currencyList
        } else {
            return currencyList.filter { $0.lowercased().contains(searchText.lowercased())}
        }
    }
    
    var body: some View {
        ZStack {
            Color.bgColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    TextField("Value", value: $input, format: .number)
                        .textFieldFrame()
                        .focused($inputIsFocused)
                        .onSubmit {
                            inputIsFocused = false
                            Task {
                                await makeRequest()
                            }
                        }
                    Spacer()
                    
                    Picker(selection: $base, label: Text("")) {
                        SearchBar(text: $searchText, placeholder: "Find currency")
                        ForEach(filteredCurrencies, id: \.self) { currency in
                            HStack(spacing: 10) {
                                
                                Text(getFlag(currency: currency))
                                Text(currency)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .frame(width: 100, height: 40)
                    .pickerFrame()
                }
                ScrollView {
                    ForEach(0..<favouritesCurrencies.count, id: \.self) { index in
                        let currency = favouritesCurrencies[index]
                        VStack(alignment: .leading) {
                            HStack {
                                
                                // Marking currency as Favourite
                                Button {
                                    if favourities.contains(currency) {
                                        favourities.remove(currency)
                                    } else {
                                        favourities.add(currency)
                                    }
                                } label: {
                                    Image(systemName: favourities.contains(currency) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.title)
                                }
                                HStack {
                                    Text(currency.name)
                                        .font(.title2)
                                        .bold()
                                    
                                    Text(getFlag(currency: currency.name))
                                        .font(.largeTitle)
                             
                                    Spacer()
                                    
                                    Text(currency.rate)
                                        .font(.title2)
                                        .bold()
                                }
                            }
                            .padding(2)
                            
                            Divider()
                                .frame(height: 1)
                                .background(.orange)
                        }
                    }
                    .foregroundColor(.white)
                }
                .padding(.vertical, 15)
                
                Button(showFavourites ? "Show All" : "Show favourites") {
                    showFavourites.toggle()
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
            }
            .padding()
            .onAppear {
                Task {
                    await makeRequest()
                }
            }
        }
    }
    
    var favouritesCurrencies: [AdjustedCurrency] {
        if showFavourites {
            return currencyArray.filter { favourities.contains($0) }
        } else {
            return currencyArray
        }
    }
    
    func makeRequest() async {
        
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
                currencyList.self = tempList
                currencyArray.self = tempArray
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

struct CurrencyAllView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CurrencyView()
        }
    }
}




