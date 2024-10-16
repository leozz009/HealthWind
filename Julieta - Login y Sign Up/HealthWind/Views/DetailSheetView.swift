//
//  DetailSheetView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct DetailSheetView: View {
    var body: some View {
        VStack{
            // Header detalle actual
            VStack {
                HStack{
                    Text("Detalle Actual")
                        .font(.title)
                    Spacer()
                }
                HStack{
                    Text("¿Cómo se encuentra la situación hoy?")
                        .foregroundColor(.secondary)
                    Spacer()
                }.padding(.bottom,40)
            }.padding(.horizontal)
          
        
            // Calidad del aire
            VStack{
                Text("Calidad del aire")
                    .foregroundColor(.secondary)
                    .fontWeight(.light)
                Text("Buena") // ESTE VALOR DEBE PASARSE COMO PARAMETRO
                    .font(.system(size: 70))
                    .foregroundColor(.greenIndex)
            }.padding(.bottom,40)
            
            VStack {
                HStack{
                    Text("Principal Contaminante")
                        .font(.title2)
                    Spacer()
                }
                HStack{
                    Text("Ozono (O3)")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }.padding(.horizontal)
            
            NavigationView {
                List {
                    Section {
                        Text("El ozono es típicamente elevado debido al tráfico, combustibles fósiles e incendios.")
                            .font(.body)
                            .cornerRadius(8)
                    }
                    
                    Section(header: Text("Otros contaminantes").font(.headline)) {
                        ForEach(0..<3) { index in
                            HStack {
                                Text("CO")
                                Spacer()
                                Text("Monóxido de Carbono")
                                Spacer()
                                Text("382 ppb")
                            }
                            .padding(.vertical, 10)
                        }
                    }
                }
                .listStyle(.plain)
            }
            
            Spacer()
        }.padding(.top, 50)
            .padding(.horizontal)
    }
}

#Preview {
    DetailSheetView()
}
