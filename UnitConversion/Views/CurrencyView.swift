//
//  CurrencyView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 08/09/2022.
//
// 

import SwiftUI

struct CurrencyView: View {
    
   
    @StateObject var favourities = Favourites()
    @StateObject var vm = CurrencyViewModel()
    
    @State private var showFavourites = false
    @State private var presentPicker = false

    var body: some View {
        ZStack {
            Color.bgColor
                .ignoresSafeArea()
            VStack {
                // Currency value and name.
                headerBar
                ZStack {
                    currenciesList
                    // Progress View while loading currencies from external API.
                    if vm.isLoading {
                        ProgressView()
                            .tint(.orange)
                            .scaleEffect(5)
                    }
                }
                favouritesButton
            }
            .padding()
            .onAppear {
                Task {
                    await vm.makeRequest()
                }
            }
            .onTapGesture {
                // Hide Keyboard after tapping anywhere
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                Task {
                    await vm.makeRequest()
                }
            }
        }
    }
    
    // Showing all the currencies or only favourites.
    var favouritesCurrencies: [AdjustedCurrency] {
        if showFavourites {
            return vm.currencyArray.filter { favourities.contains($0) }
        } else {
            return vm.currencyArray
        }
    }
}

struct CurrencyAllView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CurrencyView()
        }
    }
}

extension CurrencyView {
    
    private var headerBar: some View {
        HStack {
            // Input currency value.
            TextField("Value", value: $vm.input, format: .number)
                .textFieldFrame()

            Spacer()
            
            // Choosing the currency, default taken from user's locale.
            Picker(selection: $vm.base, label: Text("")) {
                // Typing currency name to shorten the list of all of them.
                SearchBar(text: $vm.searchText, placeholder: "Find currency")
                // List of all the currencies, filtered by the bar above.
                ForEach(vm.filteredCurrencies, id: \.self) { currency in
                    HStack(spacing: 10) {
                        // Currency flag loaded from Unicode
                        Text(vm.getFlag(currency: currency))
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
    }
    
    private var currenciesList: some View {
        ScrollView {
            ForEach(0..<favouritesCurrencies.count, id: \.self) { index in
                let currency = favouritesCurrencies[index]
                VStack(alignment: .leading) {
                    HStack {
                        
                        // Toggling currency as Favourite.
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
                            // Currency flag loaded from Unicode
                            Text(vm.getFlag(currency: currency.name))
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
    }
    
    private var favouritesButton: some View {
        Button(showFavourites ? "Show All" : "Show favourites") {
            showFavourites.toggle()
        }
        .buttonStyle(.borderedProminent)
        .font(.title2)
    }
}


