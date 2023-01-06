//
//  Constants.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 10/09/2022.
//

import Foundation
import SwiftUI


extension Color {
    // Background colour for the whole APP
    static let bgColor = Color.black
}

// Frame for main menu icons
struct OrangeFrame: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 90, height: 90)
            .foregroundColor(.black)
            .font(.title)
            .shadow(color: .blue, radius: 5)
            .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.orange, lineWidth: 2)
            )
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .frame(width: 150, height: 40)
        .padding(.horizontal)
        .foregroundColor(.white)
        .background(Color.blue.opacity(0.5))
        .font(.title)
        .bold()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .red, radius: 15, x: 0, y: 0)
        .overlay(
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 2)
            
        )
        .keyboardType(.decimalPad)
    }
}

struct PickerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .foregroundColor(.white)
            .background(Color.blue.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .red, radius: 15, x: 0, y: 0)
            .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
                )
    }
}

struct NeonStyle: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        return ZStack {
            content.foregroundColor(color)

        }
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(color, lineWidth: 4))
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(color, lineWidth: 4).brightness(0.1))
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(color, lineWidth: 4).brightness(0.1).opacity(0.2))
        .compositingGroup()
        
    }
}

extension View {
    func orangeFrame() -> some View {
        modifier(OrangeFrame())
    }
    
    func textFieldFrame() -> some View {
        modifier(TextFieldModifier())
    }
    
    func pickerFrame() -> some View {
        modifier(PickerModifier())
    }
}

