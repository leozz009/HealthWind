//
//  ContentView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
// Hola
//  TabView para saleccionar las diferentes vistas.

import SwiftUI

struct ContentView: View {
    @State var selectedTab:Int = 0
    var body: some View {
        

        TabView (selection: $selectedTab){
            MenuView()
                .padding(.top,50)
                .tabItem{
                Image(systemName: "house")
                Text("Inicio")
                
            }.tag(0)
            
            MapView(selectedTab:$selectedTab).tabItem {
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
