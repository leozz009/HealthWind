//
//  NewUserDataView.swift
//  HealthWind
//
//  Created by Leonardo González on 23/11/24.
//

import SwiftUI

struct NewUserDataView: View {
    @State private var edad: Int = 18
    @State private var genero: Gender = .male
    @State private var condicionesRespiratorias: CondicionRespiratoria = .none
    @State private var condicionesCardiovasculares: CondicionCardiovascular = .none
    @State private var nivelActividad: NivelActividad = .medium
    @State private var fumador: Bool = false

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Información General")) {
                    Picker("Edad", selection: $edad) {
                        ForEach(1...80, id: \.self) { edad in
                            Text("\(edad)").tag(edad)
                        }
                    }
                    
                    Picker("Género", selection: $genero) {
                        ForEach(Gender.allCases, id: \.self) { genero in
                            Text(genero.descr).tag(genero)
                        }
                    }
                }
                
                Section(header: Text("Condiciones Médicas")) {
                    Picker("Condiciones Respiratorias", selection: $condicionesRespiratorias) {
                        ForEach(CondicionRespiratoria.allCases, id: \.self) { condicion in
                            Text(condicion.descr).tag(condicion)
                        }
                    }
                    
                    Picker("Condiciones Cardiovasculares", selection: $condicionesCardiovasculares) {
                        ForEach(CondicionCardiovascular.allCases, id: \.self) { condicion in
                            Text(condicion.descr).tag(condicion)
                        }
                    }
                }
                
                Section(header: Text("Fumador")) {
                    Toggle("¿Eres fumador?", isOn: $fumador)
                }
                
                Section(header: Text("Actividad Física")) {
                    Picker("Nivel de actividad física", selection: $nivelActividad) {
                        ForEach(NivelActividad.allCases, id: \.self) { nivel in
                            Text(nivel.descr).tag(nivel)
                        }
                    }
                }
                
                Button("Crear Usuario") {
                    let newUser = User(
                        edad: edad,
                        genero: genero,
                        condicionesRespiratorias: condicionesRespiratorias,
                        condicionesCardiovasculares: condicionesCardiovasculares,
                        fumador: fumador,
                        nivelActividadFisica: nivelActividad
                    )
                    context.insert(newUser)
                    print("Usuario creado: \(newUser)")
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Ingresa tus datos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    Button ("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewUserDataView()
}
