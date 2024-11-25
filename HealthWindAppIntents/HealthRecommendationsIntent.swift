//
//  FetchRecommendationsIntent.swift
//  HealthWind
//
//  Created by Fatima Alonso on 11/24/24.
//

import Foundation
import AppIntents

struct FetchRecommendationsIntent: AppIntent {
    static var title: LocalizedStringResource = "Recomendaciones generales aire libre"
    static var description: LocalizedStringResource = "Obtén recomendaciones generales al salir al aire libre"
    
    @Parameter(
        title: "Tipo de Usuario",
        description: "Selecciona el grupo al que perteneces.",
        choices: [
            "Población general",
            "Personas mayores",
            "Enfermedades pulmonares",
            "Enfermedades cardíacas",
            "Atletas",
            "Mujeres embarazadas",
            "Niños"
        ]
    )
    var userType: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("Consulta recomendaciones para \(\.$userType).")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let locationVM = LocationViewModel()
        locationVM.requestLocation()
        
        while locationVM.latitude == 0.0 && locationVM.latitude == 0.0 {
            try await Task.sleep(for: .milliseconds(500))
        }
        let latitude = locationVM.latitude
        let longitude = locationVM.longitude
        
        let airQualityVM = AirQualityIndexViewModel()
        airQualityVM.fetchAirQualityIndex(latitude: latitude, longitude: longitude)
        
        while !airQualityVM.loaded {
            try await Task.sleep(for: .milliseconds(500))
        }
        
        guard let airQualityData = airQualityVM.airQualityData else {
            throw NSError(domain: "FetchRecommendationsIntent",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "No se pudieron obtener los datos"])
        }
        
        let recommendation = airQualityData.health
        let responseMessage = "Aquí tienes unas recomendaciones generales: \(recommendation). Recuerda que estas son recomendaciones para el público general. Si deseas algo más personalizado entra a la app de HealthWind para consultar tus recomendaciones personalizadas."
        
        return .result(dialog: IntentDialog(stringLiteral: responseMessage))
    }
}
