//
//  ConversionView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 07/09/2022.
//

import SwiftUI

struct ConversionView: View {
    
    @State var input: Double = 1.0
    @State var inputUnit: Dimension
    
    var outputUnit: Dimension
    var selectedUnits: Int
    
    let formatterMedium = MeasurementFormatter()
    let formatterShort = MeasurementFormatter()
    let formatterLong = MeasurementFormatter()
    
    // State to make sure the decimal keyboard is dismissed after finishing typing
    @FocusState private var inputIsFocused: Bool
    
    let constants = Constants()
    
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
                            ForEach(constants.unitTypes[selectedUnits], id: \.self) {
                                
                                Text(formatterMedium.string(from: $0).capitalized)
                            }
                        }
                    } label: {
                        Text(formatterMedium.string(from: inputUnit))
                    }
                    .frame(width: 130, height: 40)
                    .font(.title3)
                    .pickerFrame()
                    
                }
                
                ScrollView {
                    ForEach(0..<constants.unitTypes[selectedUnits].count, id: \.self) { num in
                        
                        let inputMeasurement = Measurement(value: input, unit: inputUnit)
                        let outputMeasurement = inputMeasurement.converted(to: constants.unitTypes[selectedUnits][num])
                        
                        HStack {
                            Text(formatterLong.string(from: constants.unitTypes[selectedUnits][num]).capitalized)
                            Spacer()
                            Text(formatterShort.string(from: outputMeasurement).filter("0123456789.".contains))

                       
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
            .navigationTitle("\(constants.units[selectedUnits])")
            .padding()
        }
    }
    
    func initFormatter() {
        // Short version for TextField
        formatterMedium.unitOptions = .providedUnit
        formatterMedium.unitStyle = .medium
        
        // Long version for names in List View
        formatterLong.unitOptions = .providedUnit
        formatterLong.unitStyle = .long
        
        // Output version for names in List View
        formatterShort.unitOptions = .providedUnit
        formatterShort.unitStyle = .short
    
        
        input = 0
    }
    
}

struct Conversion_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConversionView(inputUnit: UnitArea.squareKilometers, outputUnit: UnitArea.hectares, selectedUnits: 0)
            
        }
    }
}

