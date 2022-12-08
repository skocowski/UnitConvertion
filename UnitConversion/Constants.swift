//
//  Constants.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 18/09/2022.
//

import Foundation

struct Constants {
    
    // List of units
    let units = [
    "Area",
    "Length",
    "Mass",
    "Pressure",
    "Speed",
    "Temp",
    "Volume"
    ]

    // List of icons as SF symbols
    let icons = [
    "globe.europe.africa",
    "ruler",
    "leaf",
    "gauge",
    "hare",
    "thermometer",
    "homepod.and.homepodmini"
    ]

    let unitTypes = [
        [UnitArea.squareInches, UnitArea.squareFeet, UnitArea.squareYards, UnitArea.squareMeters, UnitArea.acres, UnitArea.ares, UnitArea.hectares, UnitArea.squareKilometers],
        [UnitLength.millimeters, UnitLength.centimeters, UnitLength.inches, UnitLength.decameters, UnitLength.feet, UnitLength.yards, UnitLength.meters, UnitLength.kilometers, UnitLength.miles, UnitLength.nauticalMiles],
        [UnitMass.grams, UnitMass.kilograms, UnitMass.carats, UnitMass.ounces, UnitMass.pounds, UnitMass.stones],
        [UnitPressure.hectopascals, UnitPressure.millibars, UnitPressure.kilopascals, UnitPressure.hectopascals, UnitPressure.millimetersOfMercury, UnitPressure.poundsForcePerSquareInch, UnitPressure.newtonsPerMetersSquared],
        [UnitSpeed.kilometersPerHour, UnitSpeed.milesPerHour, UnitSpeed.metersPerSecond, UnitSpeed.knots],
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cubicCentimeters, UnitVolume.cubicMeters, UnitVolume.imperialPints, UnitVolume.imperialGallons, UnitVolume.gallons]
        
    ]
}


