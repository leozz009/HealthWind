//
//  BackgroundHealthViewComponent.swift
//  HealthWind
//
//  Created by Leonardo González on 10/10/24.
//

import SwiftUI

struct BackgroundHealthViewComponent: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if(colorScheme == .dark) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.whiteApp, Color.blueApp]),
                               startPoint: .center,
                               endPoint: UnitPoint(x: 0.5, y: 1))
                .frame(height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
                
            }.padding(.bottom,250)
        }
        else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.whiteApp, Color.blueApp]),
                               startPoint: .center,
                               endPoint: UnitPoint(x: 0.5, y: 1.8))
                .frame(height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
                
            }.padding(.bottom,250)
        }
        
    }
}

#Preview {
    BackgroundHealthViewComponent()
}
