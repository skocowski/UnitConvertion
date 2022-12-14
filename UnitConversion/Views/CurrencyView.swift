//
//  CurrencyView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 08/09/2022.
//
// https://api.exchangerate.host/latest?base=\(base)&amount=\(input)

import SwiftUI

struct CurrencyView: View {
    

    @State var input = "1"
    @State var base = "USD"
    @State var selectedCurrency = "GBP"
    @State var currencyList = [String]()
    @State var currencyArray = [AdjustedCurrency]()
    
    @State var showFavourites = false
    @State private var presentPicker = false
    
    @StateObject var favourities = Favourites()
    // To make sure decimal keyboard disappear after typing
    @FocusState private var inputIsFocused: Bool

    
    var body: some View {
        ZStack {
            Color.bgColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    TextField("Enter an amount", text: $input)
                        .textFieldFrame()
                        .focused($inputIsFocused)
                    
                    Spacer()
                    
                    Menu {
                        Picker(selection: $base, label: Text("Select a currency")) {
                            ForEach(currencyList, id: \.self) {
                                Text($0)
                            }
                        }
                    } label: {
                        Text("\(base)")
                    }
                    .frame(width: 120, height: 40)
                    .pickerFrame()
                }
                
                HStack {
                    
                    Button(showFavourites ? "Show All" : "Show favourities") {
                        showFavourites.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                    
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await makeRequest()
                        }
                        
                        inputIsFocused = false
                    } label: {
                        Text("Convert")
                            .frame(width: 100)
                            .font(.title2)
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
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
                                    //    .font(.system(size: 45))
                                    
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

        getJSON(urlString: "https://api.exchangerate.host/latest?base=\(base)&amount=\(input)") { (currency: Currency?) in
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

