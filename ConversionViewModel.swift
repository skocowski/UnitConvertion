//
//  FormattingUnits.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 16/3/23.
//

import Foundation

class ConversionViewModel: ObservableObject {

    
    let formatterShort = MeasurementFormatter()
    let formatterMedium = MeasurementFormatter()
    let formatterLong = MeasurementFormatter()
    
    init() {
        // Short version for TextField
        formatterMedium.unitOptions = .providedUnit
        formatterMedium.unitStyle = .medium
        
        
        // Long version for names in List View
        formatterLong.unitOptions = .providedUnit
        formatterLong.unitStyle = .long

        
        // Output version for names in List View
        formatterShort.unitOptions = .providedUnit
        formatterShort.unitStyle = .short
    }
    

}
