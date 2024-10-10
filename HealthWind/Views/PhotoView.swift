//
//  PhotoView.swift
//  HealthWind
//
//  Created by Leonardo González on 10/10/24.
//

import SwiftUI

struct PhotoView: View {
    var body: some View {
        VStack{
            VStack(alignment: .center){
                Text("¿Qué estás observando?")
                    .font(.title2)
                Text("Toma una foto para generar un reporte de la contaminación actual en la zona en la que estás")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            VStack{
                ZStack {
                    Image(systemName: "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .font(.system(size: 10, weight: .thin))
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .font(.system(size: 10, weight: .bold))
                }.foregroundColor(.secondary)
            }.padding(.top, 50)
        }
    }
}

#Preview {
    PhotoView()
}
