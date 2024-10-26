//
//  RecommendationCardViewComponent.swift
//  HealthWind
//
//  Created by Leonardo González on 10/10/24.
//

import SwiftUI

struct RecommendationCardViewComponent: View {
    var icon : String
    var recommendation: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.icons)
                .padding(.horizontal,8)
            
            Text(recommendation)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body)
                .padding()
                .background(Color.grayComponent)
                .cornerRadius(10)
                .shadow(radius: 2)
                
                
        }.padding(.bottom,15)
            .padding(.trailing,8)
    }
}

#Preview {
    RecommendationCardViewComponent(icon: "car.fill", recommendation: "El día de hoy dismin")
}
