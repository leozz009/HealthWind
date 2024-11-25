//
//  HealthWindShortcuts.swift
//  HealthWindAppIntents
//
//  Created by Fatima Alonso on 11/11/24.
//

import Foundation
import AppIntents

struct HealthWindShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
        AppShortcut(
            intent: OpenHealthWind(),
            phrases: ["Abre HealthWind"],
            shortTitle: "Abrir HealthWind",
            systemImageName: "checklist"
            
            ),
        
        AppShortcut(
            intent: FetchAirQualityIntent(),
            phrases: ["Cómo esta la calidad del aire basado en HealthWind?"],
            shortTitle: "Calidad de aire",
            systemImageName: "wind"
        ),
        
        AppShortcut(
            intent: FetchDominantPollutantIntent(),
            phrases: ["Cuál es el contaminante dominante basado en HealthWind?"],
            shortTitle: "Contaminante dominante",
            systemImageName: "wind")
        ]
        
    }
}
