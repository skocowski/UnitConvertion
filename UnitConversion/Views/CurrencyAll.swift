//
//  CurrencyView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 08/09/2022.
//
// https://api.exchangerate.host/latest?base=\(base)&amount=\(input)

import SwiftUI

struct CurrencyAll: View {
    
    
    
    @State var input = "1"
    @State var base = "USD"
    @State var selectedCurrency = "GBP"
    @State var currencyList = [String]()
    @State var currencyArray = [NewCurrency]()
    
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
                    Button {
                        makeRequest()
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
                        HStack {
                            
                            // Marking currensy as Favourite
                            Button {
                                if favourities.contains(currency) {
                                    favourities.remove(currency)
                                } else {
                                    favourities.add(currency)
                                }
                            } label: {
                                Image(systemName: favourities.contains(currency) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            Text(currency.name)
                            Spacer()
                            Text(currency.rate)
                        }
                        .padding(2)
                        .font(.title)
                        
                        Divider()
                            .frame(height: 1)
                            .background(.orange)
                    }
                    .foregroundColor(.white)
                }
                .padding(.vertical, 15)
                
                Button(showFavourites ? "Show All" : "Show favourities") {
                    showFavourites.toggle()
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
            }
            .padding()
            .onAppear {
                makeRequest()
            }
        }
    }
    
    var favouritesCurrencies: [NewCurrency] {
        if showFavourites {
            return currencyArray.filter { favourities.contains($0) }
        } else {
            return currencyArray
        }
    }
    
    func makeRequest() {

        getJSON(urlString: "https://api.exchangerate.host/latest?base=\(base)&amount=\(input)") { (currency: Currency?) in
            var tempList = [String]()
            var tempArray = [NewCurrency]()
            
            if let currency = currency {
                for currency in currency.rates {
                    tempList.append("\(currency.key)")
                    
                    var formattedRate: String {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.maximumFractionDigits = 2
                        formatter.decimalSeparator = "."
                        formatter.groupingSeparator = " "
                        
                        return formatter.string(from: currency.value as NSNumber) ?? ""
                    }
                    tempArray.append(NewCurrency(name: currency.key, rate: formattedRate))
                }
            }
            

            tempList.sort()
            tempArray.sort { (lhs: NewCurrency, rhs: NewCurrency) -> Bool in
                return lhs.name < rhs.name
            }
            currencyList.self = tempList
            currencyArray.self = tempArray
        }
    }
}

struct CurrencyAllView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CurrencyAll()
        }
    }
}
