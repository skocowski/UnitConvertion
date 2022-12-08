//
//  MenuItem.swift
//  UnitConversion
//
//  Created by Szymon Kocowski on 10/09/2022.
//

import SwiftUI

struct MenuItem: View {
    
    var image = ""
    var text = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .orangeFrame()

            VStack(spacing: 7) {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
            }
        }
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem()
    }
}
