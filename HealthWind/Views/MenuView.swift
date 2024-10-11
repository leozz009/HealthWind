//
//  MenuView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct MenuView: View {
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            BackgroundViewComponent()  // Componente de fondo
            // Saludo y profile image
            VStack {
                HStack {
                    Text("Bienvenido")
                        .font(.title)
                        .foregroundColor(.white)
                        
                    Spacer()
                    Circle()
                        .frame(width: 50)
                        .foregroundColor(.white)
                }.padding(.top,50)
                
                // Imagen de la nube y texto descriptivo
                VStack{
                    Text("🌥️")
                        .font(.system(size: 125))
                    VStack {
                        Text("Parcialmente Nublado")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.gray)
                            
                        Text("Domingo, 6 de octubre del 2024")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }.padding(.bottom,10)
                }.padding().offset(y:-20)
                
                // Ubicación, Calidad del aire y contaminantes
                VStack {
                    HStack{
                        Text("Monterrey, Nuevo León")
                            .font(.title2)
                        Spacer()
                    }.padding(.bottom,5)
                    
                    HStack{
                        Text("Calidad del aire")
                            .foregroundColor(.secondary)
                        Spacer()
                    }.offset(y:15)
                    HStack{
                        Text("Buena")
                            .font(.system(size: 60))
                            .foregroundColor(.greenIndex)
                        Spacer()
                        VStack(alignment:.trailing){
                            Text("Indice de calidad: 20")
                                .padding(.all,5)
                                .background(.greenIndexMenuView)
                                .cornerRadius(8)
                            Text("PM2.5, PM10")
                                .foregroundColor(.white)
                                .padding(.all,5)
                                .background(.gray)
                                .cornerRadius(8)
                        }.font(.caption)
                    }
                }.padding(.bottom,5)
                
                // Pronóstico semanal -> Deslizamiento
                
                VStack{
                    HStack{
                        Text("Pronóstico Semanal")
                            .foregroundColor(.secondary)
                        Spacer()
                    }.padding(.bottom,10)
                    ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForecastCardViewComponent(indice: 34, day: "Lun")
                                    ForecastCardViewComponent(indice: 90, day: "Mar")
                                    ForecastCardViewComponent(indice: 102, day: "Mie")
                                    ForecastCardViewComponent(indice: 160, day: "Jue")
                                    ForecastCardViewComponent(indice: 34, day: "Vie")
                                }
                                .padding(.all,5)
                            }
                            .frame(height: 110)
                }
                
                // Botón para ir al detalle actual
                
                VStack{
                    Button("Ver detalle actual"){
                        showingSheet.toggle()
                    }.buttonStyle(.borderedProminent)
                        .tint(.blueApp)
                }
                .padding(.top, 20)
                .sheet(isPresented: $showingSheet){
                    DetailSheetView()
                        .presentationDetents([.height(650)])
                }
                Spacer()
            }
            .padding(.horizontal,25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MenuView()
}
