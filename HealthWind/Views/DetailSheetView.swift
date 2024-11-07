//
//  DetailSheetView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct DetailSheetView: View {
    @Environment(\.dismiss) var dismiss // Permite cerrar la vista
    @StateObject private var airPolutionDetails = AirQualitySheetViewModel()

    var body: some View {
        VStack {
            // Indicador de desplazamiento
            Rectangle()
                .frame(width: 40, height: 6)
                .foregroundColor(Color.gray.opacity(0.5))
                .cornerRadius(3)
                .padding(.top)
                .offset(y: 8)
        
    
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        
            // Header detalle actual
            VStack {
                HStack {
                    Text("Detalle Actual")
                        .font(.title2)
                    Spacer()
                }
                HStack {
                    Text("¿Cómo se encuentra la situación hoy?")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal)
            .padding(.top,12)

            // Calidad del aire
            VStack {
                Text("Calidad del aire")
                    .foregroundColor(.secondary)
                    .fontWeight(.light)
                Text(capitalizedFirstLetter("\(airPolutionDetails.airQualityCompleteInformation?.indexes.last?.category ?? "N/A")"))
                    .font(.system(size: 60))
                    .foregroundColor(airPolutionDetails.airQualityCompleteInformation?.indexes.last?.color.colorforSwiftUI ?? .gray)
            }
            .padding(.bottom, 40)

            VStack {
                HStack {
                    Text("Principal Contaminante")
                        .font(.title3)
                    Spacer()
                }
                HStack {
                    Text(getWordUppercase(text: "\(airPolutionDetails.airQualityCompleteInformation?.indexes.last?.dominantPollutant ?? "N/A")"))
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .padding(.horizontal)

            NavigationView {
                List {
                    Section {
                        if let dominantPollutantCode = airPolutionDetails.airQualityCompleteInformation?.indexes.last?.dominantPollutant {
                            if let pollutant = airPolutionDetails.airQualityCompleteInformation?.pollutants.first(where: { $0.code == dominantPollutantCode }) {
                                Text(pollutant.additionalInfo.sources)
                                    .font(.body)
                                    .cornerRadius(8)
                            } else {
                                Text("No se encontró la descripción del contaminante")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Text("No hay un contaminante dominante")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }

                    Section(header: Text("Otros contaminantes").font(.headline)) {
                        if let pollutants = airPolutionDetails.airQualityCompleteInformation?.pollutants {
                            ForEach(pollutants, id: \.code) { pollutant in
                                HStack {
                                    Text(pollutant.code.uppercased())
                                    Spacer()
                                    Text(pollutant.fullName)
                                        .lineLimit(1)
                                    Spacer()
                                    
                                    Text("\(pollutant.concentration.value, specifier: "%.1f")") // Concentración y unidades en minúsculas
                                }
                                .padding(.vertical, 10)
                            }
                        } else {
                            Text("No se encontraron contaminantes.")
                        }
                    }
                }
                .listStyle(.plain)
            }

            Spacer()
        }
        .padding(.top, 10) // Ajusta este padding según necesites
        .padding(.horizontal)
        .onAppear {
            airPolutionDetails.fetchAirQualityData(latitude: 25.6866, longitude: -100.3161)
        }
    }
}

// Funciones necesarias para que sea presentable esta vista

func getLastWordWithCapitalization(text: String) -> String {
    let words = text.components(separatedBy: " ")
    guard let lastWord = words.last else { return "" }

    return lastWord.capitalized // Poner en mayuscula la última palabra
}

func getWordUppercase(text: String) -> String {
    return text.uppercased()
}

func capitalizedFirstLetter(_ string: String) -> String {
    return string.prefix(1).capitalized + string.dropFirst()
}


#Preview {
    DetailSheetView()
}
