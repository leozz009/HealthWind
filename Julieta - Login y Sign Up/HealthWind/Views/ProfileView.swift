//
//  ProfileView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedSegment = 0
    var body: some View {
        VStack{
            ZStack{
                BackgroundViewComponent()
                
                // Imagen de perfil y nombre
                VStack{
                    ProfileCircleImageViewComponent(profileImage: Image("profileImage"), systemImage: "pencil.circle.fill", borderColor: Color.blueApp)
                    Text("Arely Salinas")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    // Picker para ver los datos
                    VStack{
                        Picker("Selecciona una opción", selection: $selectedSegment) {
                            Text("Información").tag(0)
                            Text("Datos Médicos").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    if(selectedSegment == 0){
                        List {
                            Section(header: Text("INFORMACIÓN PERSONAL").font(.subheadline)) {
                                HStack {
                                    Text("Edad")
                                    Spacer()
                                    Text("27")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                                
                                HStack {
                                    Text("Género")
                                    Spacer()
                                    Text("Female")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                                
                                HStack {
                                    Text("Nacionalidad")
                                    Spacer()
                                    Text("Mexicana")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                            }
                            
                            Section(header: Text("UBICACIÓN").font(.subheadline)) {
                                HStack {
                                    Text("País")
                                    Spacer()
                                    Text("México")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                                
                                HStack {
                                    Text("Estado")
                                    Spacer()
                                    Text("Nuevo León")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                            }
                        }
                        .listStyle(InsetListStyle()) // Estilo opcional
                        
                    }else{
                        List {
                            Section(header: Text("INFORMACIÓN CORPORAL").font(.subheadline)) {
                                HStack {
                                    Text("Altura")
                                    Spacer()
                                    Text("1.65")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                                
                                HStack {
                                    Text("Peso")
                                    Spacer()
                                    Text("66")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                                
                                HStack {
                                    Text("IMC")
                                    Spacer()
                                    Text("24")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                                
                                HStack {
                                    Text("Sangre")
                                    Spacer()
                                    Text("A+")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                            }
                            
                            Section(header: Text("ENFERMEDADES").font(.subheadline)) {
                                HStack {
                                    Text("Respiratorias")
                                    Spacer()
                                    Text("Asma")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                                
                                HStack {
                                    Text("Cardiovasculares")
                                    Spacer()
                                    Text("Ninguna")
                                        .foregroundStyle(.gray)
                                        .fontWeight(.light)
                                }
                            }
                        }.listStyle(InsetListStyle())
                    }
                }.padding(.top,90).padding()
            }
        }
    }
}

#Preview {
    ProfileView()
}
