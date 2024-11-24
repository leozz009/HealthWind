//
//  OpenHealthWind.swift
//  HealthWindAppIntents
//
//  Created by Fatima Alonso on 11/23/24.
//

import Foundation
import AppIntents

struct OpenHealthWind: AppIntent {
    static var title: LocalizedStringResource = "Abre Health Wind"
    
    @MainActor
    func perform() async throws -> some IntentResult {
        
        return .result()
        
    }
    
    static var openAppWhenRun: Bool = true
}
