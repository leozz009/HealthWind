//
//  AppDependencies.swift
//  HealthWind
//
//  Created by Fatima Alonso on 11/21/24.
//

import Foundation

class AppDependencies {
    static let shared = AppDependencies()
    
    // Instancia global del ViewModel
    let airQualityViewModel = AirQualityIndexViewModel()
    
    private init() {} // Asegura que no se pueda instanciar desde afuera
}
