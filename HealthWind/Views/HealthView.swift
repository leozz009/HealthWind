//
//  HealthView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct HealthView: View {
    var body: some View {
        
        ZStack {
            BackgroundHealthViewComponent()
            VStack{
                ProfileCircleImageViewComponent(profileImage: Image("profileImage"), systemImage: "heart.circle.fill", borderColor:.red)
                
                VStack(alignment: .leading) {
                    // Asegurarse de que el texto esté alineado a la izquierda
                    Text("Recomendaciones del día: ")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .fontWeight(.light)
                        .padding(.horizontal, 15)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top,30)
                
                VStack{
                    RecommendationCardViewComponent(icon: "heart.circle.fill", recommendation: "El día de hoy disminuye el uso del automóvil y opta por actividades como andar en bicicleta o caminar.")
                    RecommendationCardViewComponent(icon: "car.circle.fill", recommendation: "El día de hoy disminuye el uso del automóvil y opta por actividades como andar en bicicleta o caminar.")
                    RecommendationCardViewComponent(icon: "tree.circle", recommendation: "El día de hoy disminuye el uso del automóvil y opta por actividades como andar en bicicleta o caminar.")
                }.padding(.top,8)
            }.padding(.horizontal)
        }
    }
}

#Preview {
    HealthView()
}
