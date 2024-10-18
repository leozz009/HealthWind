//
//  ForoView.swift
//  HealthWind
//
//  Created by Leonardo González on 10/10/24.
//

import SwiftUI

struct ForoView: View {
    var body: some View {
        ScrollView{
            PostViewComponent(profileImage: Image("profileImage"), name: "Arely Salinas", date: "10 Oct", description: "Hay reportes e contaminación en la zona urbana de Monterrey. Se recomienda no salir para evitar riesgos en la salud .", reportImage: Image("monterrey"))
            
            PostViewComponent(profileImage: Image("profileImage"), name: "Arely Salinas", date: "10 Oct", description: "Hay reportes e contaminación en la zona urbana de Monterrey. Se recomienda no salir para evitar riesgos en la salud .", reportImage: Image("monterrey"))
            
            PostViewComponent(profileImage: Image("profileImage"), name: "Arely Salinas", date: "10 Oct", description: "Hay reportes e contaminación en la zona urbana de Monterrey. Se recomienda no salir para evitar riesgos en la salud .", reportImage: Image("monterrey"))
            
        }.scrollIndicators(.hidden)
    }
}

#Preview {
    ForoView()
}
