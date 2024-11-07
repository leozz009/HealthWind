//
//  ForecastCardViewComponent.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct ForecastCardViewComponent: View {
    var indice: Int;
    var day: String;
    var color: Color;
    
    var body: some View {
        VStack {
            VStack {
                Text("\(indice)")
                    .font(.system(size:200))
                    .minimumScaleFactor(0.01)

                    .foregroundColor(color)
                
            }
            .frame(width: 60, height: 60)
            .padding(.all,8)
            .background(.grayComponent)
            .cornerRadius(12)
            .shadow(color:color,radius: 4)
            
            Text(day)
                .foregroundColor(.secondary)
        }
        
    }
}

#Preview {
    ForecastCardViewComponent(indice: 150, day: "Lun", color: .orange)
}
