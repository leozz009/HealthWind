//
//  BackgroundViewComponent.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct BackgroundViewComponent: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blueApp, Color.whiteApp]),
                           startPoint: .top,
                           endPoint: UnitPoint(x: 0.5, y: 0.45))
            .frame(height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    BackgroundViewComponent()
}
