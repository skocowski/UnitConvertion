//
//  ConversionView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 07/09/2022.
//

import SwiftUI

struct ConversionView: View {
    @StateObject var vm = ConversionViewModel()
    @State var input: Double?
    @State var inputUnit: Dimension
    
    var outputUnit: Dimension
    var selectedUnits: Int
    let constants = Constants()
    @FocusState private var inputIsFocused: Bool
    var body: some View {
        
        ZStack {
            Color.bgColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    TextField("0", value: $input, format: .number)
                        .textFieldFrame()
                        .keyboardType(.numberPad)
                        .focused($inputIsFocused)
                    
                    Spacer()
                    
                    Menu {
                        Picker(selection: $inputUnit, label: Text("Select unit")) {
                            ForEach(constants.unitTypes[selectedUnits], id: \.self) {
                                Text(vm.formatterMedium.string(from: $0).capitalized)
                            }
                        }
                    } label: {
                        Text(vm.formatterMedium.string(from: inputUnit))
                    }
                    .frame(width: 130, height: 40)
                    .font(.title3.weight(.bold))
                    .pickerFrame()
                }
                
                ScrollView {
                    ForEach(0..<constants.unitTypes[selectedUnits].count, id: \.self) { num in
                        
                        let inputMeasurement = Measurement(value: input ?? 0, unit: inputUnit)
                        let outputMeasurement = inputMeasurement.converted(to: constants.unitTypes[selectedUnits][num])
                        
                        HStack {
                            Text(vm.formatterLong.string(from: constants.unitTypes[selectedUnits][num]).capitalized)
                            Spacer()
                            Text("\(outputMeasurement.value.formatted())")
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
            .navigationTitle("\(constants.units[selectedUnits])")
            .padding()
        }
    }
}
