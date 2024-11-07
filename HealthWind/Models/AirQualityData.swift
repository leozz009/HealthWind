//
//  AirQualityData.swift
//  HealthWind
//
//  Created by Leonardo González on 06/11/24.
//

import Foundation
import SwiftUI

struct AirQualityData: Decodable {
    let dateTime: String
    let regionCode: String
    let indexes: [Index]
    let pollutants: [Pollutant]
    let healthRecommendations: HealthRecommendations
}

struct Index: Codable {
    let code: String
    let displayName: String
    let aqi: Int?
    let aqiDisplay: String?
    let color: IndexColor
    let category: String
    let dominantPollutant: String
}

struct IndexColor: Codable {
    let red: Double?
    let green: Double?
    let blue: Double?

    var colorforSwiftUI: Color {
        Color(red: red ?? 0, green: green ?? 0, blue: blue ?? 0)
    }
}


struct Pollutant: Codable {
    let code: String
    let displayName: String
    let fullName: String
    let concentration: Concentration
    let additionalInfo: AdditionalInfo
}

struct Concentration: Codable {
    let value: Double
    let units: String
}

struct AdditionalInfo: Codable {
    let sources: String
    let effects: String
}

struct HealthRecommendations: Codable {
    let generalPopulation: String
    let elderly: String
    let lungDiseasePopulation: String
    let heartDiseasePopulation: String
    let athletes: String
    let pregnantWomen: String
    let children: String
}

