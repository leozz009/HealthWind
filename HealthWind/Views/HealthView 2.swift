//
//  HealthView 2.swift
//  HealthWind
//
//  Created by Rafael Alejandro Rivas González on 07/11/24.
//


//
//  HealthView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI


struct HealthView: View {
    @Binding var viewModel: HealthViewModel
    
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
                if(!viewModel.loadedRecommendationes){
                    Text("No hay recomendaciones disponibles")
                }
                else {
                    VStack{
                        ForEach(viewModel.recommendations, id: \.self){recommendation in
                            RecommendationCardViewComponent(icon: "heart.circle.fill", recommendation: recommendation)
                        }
                    }.padding(.top,8)
                }
                
            }.padding(.horizontal)
        }.task{
            if(!viewModel.loadedRecommendationes){
                await viewModel.getChatReply()
            }
            
        }
    }
}

#Preview {
    HealthView(viewModel: .constant(HealthViewModel()))
}


