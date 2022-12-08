//
//  ConversionView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 07/09/2022.
//

import SwiftUI

struct ConversionView: View {
    
    @State private var input = 0.0
    @State var inputUnit: Dimension
    
    var outputUnit: Dimension
    var selectedUnits: Int
    
    // Short version for TextField and results
    let formatter = MeasurementFormatter()
    
    // Long version for names in List View
    let formatterMenu = MeasurementFormatter()
    
    // State to make sure the decimal keyboard is dismissed after finishing typing
    @FocusState private var inputIsFocused: Bool
    
    var body: some View {
        
        ZStack {
            Color.bgColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    TextField("Value", value: $input, format: .number)
                        .textFieldFrame()
                        .focused($inputIsFocused)
                    
                    Spacer()
                    
                    Menu {
                        Picker(selection: $inputUnit, label: Text("Select unit")) {
                            ForEach(Constants().unitTypes[selectedUnits], id: \.self) {
                                
                                Text(formatter.string(from: $0).capitalized)
                            }
                        }
                    } label: {
                        Text(formatter.string(from: inputUnit))
                    }
                    .frame(width: 130, height: 40)
                    .font(.title3)
                    .pickerFrame()
                    
                }
                
                ScrollView {
                    ForEach(0..<Constants().unitTypes[selectedUnits].count, id: \.self) { num in
                        
                        let inputMeasurement = Measurement(value: input, unit: inputUnit)
                        let outputMeasurement = inputMeasurement.converted(to: Constants().unitTypes[selectedUnits][num])
                        
                        HStack {
                            Text(formatter.string(from: Constants().unitTypes[selectedUnits][num]).capitalized)
                            Spacer()
                            Text(formatter.string(from: outputMeasurement))
                        }
                        .padding(2)
                        .font(.title2)
                        
                        Divider()
                            .frame(height: 1)
                            .background(.orange)
                    }
                }
                .foregroundColor(.white)
            }
            .onAppear(perform: initFormatter)
            .navigationTitle("\(Constants().units[selectedUnits])")
            .padding()
        }
    }
    
    func initFormatter() {
        // Short version for TextField and results
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
        
        // Long version for names in List View
        formatterMenu.unitOptions = .providedUnit
        formatterMenu.unitStyle = .long
    }
    
}

struct Conversion_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConversionView(inputUnit: UnitArea.squareKilometers, outputUnit: UnitArea.hectares, selectedUnits: 0)
            
        }
    }
}
