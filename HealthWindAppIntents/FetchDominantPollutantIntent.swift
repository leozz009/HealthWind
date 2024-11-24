//
//  FetchDominantPollutantIntent.swift
//  HealthWindAppIntents
//
//  Created by Fatima Alonso on 11/23/24.
//

import Foundation
import AppIntents


struct FetchDominantPollutantIntent: AppIntent {
    static var title: LocalizedStringResource = "Obtener contaminante dominante"
    static var description = IntentDescription("Obtiene el contaminante dominante.")
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog{
        // Crear una instancia del ViewModel de ubicación
        let locationVM = LocationViewModel()
        locationVM.requestLocation()
        
        // Espera a que se actualicen las coordenadas
        while locationVM.latitude == 0.0 && locationVM.longitude == 0.0 {
            try await Task.sleep(nanoseconds: 500_000_000) // Espera 0.5 segundos
        }
        
        let latitude = locationVM.latitude
        let longitude = locationVM.longitude
        
        // Crear el ViewModel de calidad del aire
        let airQualityVM = AirQualityIndexViewModel()
        airQualityVM.fetchAirQualityIndex(latitude: latitude, longitude: longitude)
        
        // Espera a que los datos de calidad del aire estén listos
        while !airQualityVM.loaded {
            try await Task.sleep(nanoseconds: 500_000_000) // Espera 0.5 segundos
        }
        
        guard let airQualityData = airQualityVM.airQualityData else {
            throw NSError(domain: "FetchAirQualityIntent", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se pudieron obtener los datos de calidad del aire."])
        }
        
        // Procesar y devolver los resultados
        if let index = airQualityData.indexes.first {
            let responseMessage = """
            El contaminante dominante es \(index.dominantPollutant).
            """
            return .result(dialog: IntentDialog(stringLiteral: responseMessage))
            
        } else {
            throw NSError(domain: "FetchAirQualityIntent", code: 2, userInfo: [NSLocalizedDescriptionKey: "No hay índices de calidad del aire disponibles."])
        }
    }
}

