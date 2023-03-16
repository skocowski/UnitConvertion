//
//  MainView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 06/09/2022.
//

import SwiftUI

struct MainView: View {
    let constants = Constants()
    
    init() {
        // Navigation Bar Title font colour.
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
    }
    
    // Columns for LazyGrid
    let columns: [GridItem] = [ GridItem(.adaptive(minimum: 100, maximum: 140),spacing: 10, alignment: .top) ]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack(alignment: .top) {
                    Color.bgColor
                        .ignoresSafeArea()
                    mainBody
                        .toolbar(.hidden)
                }
            }
        } else {
            // Fallback on earlier versions
            NavigationView {
                ZStack(alignment: .top) {
                    Color.bgColor
                        .ignoresSafeArea()
                    mainBody
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
    }
}

extension MainView {
    private var mainBody: some View {
        
        VStack {
            Text("\(Image(systemName: "wand.and.stars.inverse"))UnitConverter")
                .font(Font.custom("SnellRoundHand", size: 50))
                .modifier(NeonStyle(color: .orange))
                .padding(.bottom)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    NavigationLink {
                        
                        CurrencyView()
                        
                    } label: {
                        MenuItem(image: "dollarsign.circle", text: "Currency")
                    }
                    ForEach(Array(constants.units.enumerated()), id: \.offset) { index, unit in
                        NavigationLink(destination: {
                            ConversionView(inputUnit: constants.unitTypes[index][0], outputUnit: constants.unitTypes[index][0], selectedUnits: index)
                        }, label: {
                            MenuItem(image: constants.icons[index], text: constants.units[index])
                        })
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .padding(.bottom)
        }
    }
}


