//
//  ConversionView.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 07/09/2022.
//

import SwiftUI

struct ConversionView: View {
    @StateObject var vm = ConversionViewModel()
    let constants = Constants()
    
    @State var input: Double?
    @State var inputUnit: Dimension
    
    var outputUnit: Dimension
    var selectedUnits: Int
    
    var body: some View {
        
        ZStack {
            Color.bgColor
                .ignoresSafeArea()
            VStack {
                headerBar
                resultsList
            }
            .navigationTitle("\(constants.units[selectedUnits])")
            .padding(.bottom)
            .padding(.horizontal, 1)
            .onTapGesture {
                // Hide Keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

extension ConversionView {
    private var headerBar: some View {
        HStack {
            TextField("0", value: $input, format: .number)
                .textFieldFrame()
                .keyboardType(.numberPad)
            
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
    }
    
    private var resultsList: some View {
        ScrollView {
            ForEach(0..<constants.unitTypes[selectedUnits].count, id: \.self) { num in
                
                let inputMeasurement = Measurement(value: input ?? 0, unit: inputUnit)
                let outputMeasurement = inputMeasurement.converted(to: constants.unitTypes[selectedUnits][num])
                
                HStack {
                    Text(vm.formatterLong.string(from: constants.unitTypes[selectedUnits][num]).capitalized)
                    Spacer()
                    Text(vm.numberFormatter.string(from: outputMeasurement.value as NSNumber) ?? "")
                        .padding(.trailing, 1)
                }
                .padding(2)
                .font(.title2)
                
                Divider()
                    .frame(height: 1)
                    .background(.orange)
            }
        }
        .scrollIndicators(.hidden)
        .foregroundColor(.white)
        .padding(.top, 5)
    }
}
