//
//  MainView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 06/09/2022.
//

import SwiftUI

struct MainView: View {
    
    init() {
        
        // Navigation Bar Title font colour.
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
    }
    let constants = Constants()
    // Columns for LazyGrid
    let columns: [GridItem] = [ GridItem(.adaptive(minimum: 100, maximum: 140),spacing: 10, alignment: .top) ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                    Color.bgColor
                        .ignoresSafeArea()
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(Array(constants.units.enumerated()), id: \.offset) { index, unit in
                            NavigationLink(destination: {
                                ConversionView(inputUnit: constants.unitTypes[index][0], outputUnit: constants.unitTypes[index][0], selectedUnits: index)
                            }, label: {
                                MenuItem(image: constants.icons[index], text: constants.units[index])
                            })
                        }
                        NavigationLink {
                            CurrencyAll()
                        } label: {
                            MenuItem(image: "dollarsign.circle", text: "Currency")
                        }
                    }
                    .padding()
                }
                .navigationTitle("Unit Conversion")
                .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()

    }
}
