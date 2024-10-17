//
//  BackgroundHealthViewComponent.swift
//  HealthWind
//
//  Created by Leonardo González on 10/10/24.
//

import SwiftUI

struct BackgroundHealthViewComponent: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blueApp, Color.black]),
                           startPoint: .bottom,
                           endPoint: UnitPoint(x: -0.1, y: 0.85))
            .frame(height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.top)
            
        }.padding(.bottom,250)
        
    }
}

#Preview {
    BackgroundHealthViewComponent()
}
