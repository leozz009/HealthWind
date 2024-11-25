//
//  ProfileView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [User] // Recupera todos los usuarios almacenados en SwiftData
    @State private var selectedSegment = 0
    
    var body: some View {
        VStack {
            ZStack {
                BackgroundViewComponent()
                
                VStack {
                    // Imagen de perfil y nombre
                    ProfileCircleImageViewComponent(profileImage: Image("profileImage"), systemImage: "pencil.circle.fill", borderColor: .blueApp)
                    
                    if let user = users.first { // Asegúrate de que exista al menos un usuario
                        Text(user.genero.descr) // Muestra el género como nombre (puedes cambiarlo)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        // Picker para ver los datos
                        Picker("Selecciona una opción", selection: $selectedSegment) {
                            Text("Información").tag(0)
                            Text("Datos Médicos").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if selectedSegment == 0 {
                            List {
                                Section(header: Text("INFORMACIÓN PERSONAL").font(.subheadline)) {
                                    HStack {
                                        Text("Edad")
                                        Spacer()
                                        Text("\(user.edad)")
                                            .foregroundStyle(.gray)
                                            .fontWeight(.light)
                                    }
                                    
                                    HStack {
                                        Text("Género")
                                        Spacer()
                                        Text(user.genero.descr)
                                            .foregroundStyle(.gray)
                                            .fontWeight(.light)
                                    }
                                }
                            }
                            .listStyle(InsetListStyle())
                        } else {
                            List {
                                Section(header: Text("ENFERMEDADES").font(.subheadline)) {
                                    HStack {
                                        Text("Respiratorias")
                                        Spacer()
                                        Text(user.condicionesRespiratorias.descr)
                                            .foregroundStyle(.gray)
                                            .fontWeight(.light)
                                    }
                                    
                                    HStack {
                                        Text("Cardiovasculares")
                                        Spacer()
                                        Text(user.condicionesCardiovasculares.descr)
                                            .foregroundStyle(.gray)
                                            .fontWeight(.light)
                                    }
                                }
                                
                                Section(header: Text("ESTILO DE VIDA").font(.subheadline)) {
                                    HStack {
                                        Text("Fumador")
                                        Spacer()
                                        Text(user.fumador ? "Sí" : "No")
                                            .foregroundStyle(.gray)
                                            .fontWeight(.light)
                                    }
                                    
                                    HStack {
                                        Text("Actividad Física")
                                        Spacer()
                                        Text(user.nivelActividadFisica.descr)
                                            .foregroundStyle(.gray)
                                            .fontWeight(.light)
                                    }
                                }
                            }
                            .listStyle(InsetListStyle())
                        }
                    } else {
                        Text("No hay información, presiona la imagen")
                            .font(.headline)
                            .foregroundStyle(.gray)
                            .padding()
                        Spacer()
                    }
                }
                .padding(.top, 90)
                .padding()
            }
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: User.self, inMemory: true) // Utiliza un contenedor de modelo en memoria
}
