//
//  ProfileCircleImageViewComponent.swift
//  HealthWind
//
//  Created by Leonardo González on 10/10/24.
//

import SwiftUI

struct ProfileCircleImageViewComponent: View {
    var profileImage: Image
    var systemImage: String
    var borderColor: Color
    @State private var isPresented: Bool = false  // Estado para controlar la presentación de la hoja

    var body: some View {
        ZStack {
            profileImage
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 200, height: 200)
                .overlay(Circle().stroke(borderColor, lineWidth: 4))
                .shadow(radius: 10)
            
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 43))
                    .offset(x: 70, y: 75)
                    .foregroundColor(.white)
                
                Image(systemName: systemImage)
                    .font(.system(size: 43))
                    .offset(x: 70, y: 75)
                    .foregroundColor(borderColor)
            }
        }
        .onTapGesture {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            NewUserDataView()
                .presentationDetents([.medium])
        }
    }
}


#Preview {
    ProfileCircleImageViewComponent(profileImage: Image("profileImage"), systemImage: "pencil.circle.fill", borderColor: Color.red)
}
