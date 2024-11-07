//
//  DailyForecast.swift
//  HealthWind
//
//  Created by Leonardo González on 05/11/24.
//
import Foundation
import SwiftUI

// Define la estructura para el pronóstico diario
struct DailyForecast: Decodable {
    let dateTime: String
    let indexes: [AirQualityIndex]
}

// Define la estructura para el índice de calidad del aire
struct AirQualityIndex: Codable {
    let code: String
    let displayName: String
    let aqi: Int
    let aqiDisplay: String
    let color: ForecastColor // Renombrado a ForecastColor
    let category: String
    let dominantPollutant: String
}

// Define la estructura para el color del índice de calidad del aire
struct ForecastColor: Codable {
    let red: Double?
    let green: Double?
    let blue: Double?

    var swiftUIColor: Color {
        Color(red: red ?? 0.0, green: green ?? 0.0, blue: blue ?? 0.0)
    }
}

// Define la estructura principal para el pronóstico
struct WeatherForecast: Decodable {
    let hourlyForecasts: [DailyForecast]
    let regionCode: String
}
