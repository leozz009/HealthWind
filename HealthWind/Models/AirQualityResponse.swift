//
//  AirQualityResponse.swift
//  HealthWind
//
//  Created by Leonardo González on 01/11/24.
//

import Foundation
import SwiftUI

// Modelo principal para la respuesta
struct AirQualityResponse: Decodable {
    let dateTime: String
    let regionCode: String
    let indexes: [AQIIndex]
}

// Modelo para los índices de calidad del aire
struct AQIIndex: Codable {
    let code: String
    let displayName: String
    let aqi: Int
    let aqiDisplay: String
    let color: AQIColor
    let category: String
    let dominantPollutant: String
}

// Modelo para el color asociado al índice AQI
struct AQIColor: Codable {
    let red: Double?
    let green: Double?
    let blue: Double?
    
    var swiftUIColor: Color {
        Color(red: red ?? 0, green: green ?? 0, blue: blue ?? 0)
    }
}

// Ejemplo de decodificación del JSON
func decodeAirQualityResponse(from jsonData: Data) throws -> AirQualityResponse {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601 // Configuración para fechas en formato ISO 8601
    return try decoder.decode(AirQualityResponse.self, from: jsonData)
}
