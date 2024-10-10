//
//  ContentView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//  TabView para saleccionar las diferentes vistas.

import SwiftUI

struct ContentView: View {
    var body: some View {
        @State var selectedTab = 0

        TabView (selection: $selectedTab){
            MenuView()
                .padding(.top,50)
                .tabItem{
                Image(systemName: "house")
                Text("Inicio")
                
            }.tag(0)
            
            MapView().tabItem {
                Image(systemName: "map")
                Text("Mapa")
            }.tag(1)
            
            NavigationView {  // Agregar NavigationView solo en ReportView
                ReportView()
                    .navigationTitle("Reporte")  // Título nativo
            }
            .tabItem {
                Image(systemName: "camera")
                Text("Reporte")
            }.tag(2)
            
            HealthView().tabItem {
                Image(systemName: "heart")
                Text("Salud")
            }.tag(3)
            
            HealthView().tabItem {
                Image(systemName: "person.fill")
                Text("Perfil")
            }.tag(4)
        }
    }
}

#Preview {
    ContentView()
}
