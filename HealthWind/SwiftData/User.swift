//
//  User.swift
//  HealthWind
//
//  Created by Leonardo González on 23/11/24.
//

import Foundation
import SwiftData

@Model
class User {
    var edad: Int
    var genero: Gender
    var condicionesRespiratorias: CondicionRespiratoria
    var condicionesCardiovasculares: CondicionCardiovascular
    var fumador: Bool
    var nivelActividadFisica: NivelActividad

    init(
        edad: Int,
        genero: Gender,
        condicionesRespiratorias: CondicionRespiratoria,
        condicionesCardiovasculares: CondicionCardiovascular,
        fumador: Bool = false,
        nivelActividadFisica: NivelActividad
    ) {
        self.edad = edad
        self.genero = genero
        self.condicionesRespiratorias = condicionesRespiratorias
        self.condicionesCardiovasculares = condicionesCardiovasculares
        self.fumador = fumador
        self.nivelActividadFisica = nivelActividadFisica
    }
}

// Enum para Género
enum Gender: String, Codable, CaseIterable {
    case male = "Masculino"
    case female = "Femenino"
    case other = "Otro"
    
    var id: Self { self }
    
    var descr: String {
        switch self {
        case .male: return "Masculino"
        case .female: return "Femenino"
        case .other: return "Otro (no especificado)"
        }
    }
}

// Enum para Condiciones Respiratorias
enum CondicionRespiratoria: String, Codable, CaseIterable {
    case asthma = "Asma"
    case copd = "Enfermedad pulmonar obstructiva crónica"
    case allergies = "Alergias respiratorias"
    case none = "Ninguna"
    
    var id: Self { self }
    
    var descr: String {
        switch self {
        case .asthma: return "Asma"
        case .copd: return "EPOC"
        case .allergies: return "Alergias respiratorias"
        case .none: return "Ninguna"
        }
    }
}

// Enum para Condiciones Cardiovasculares
enum CondicionCardiovascular: String, Codable, CaseIterable {
    case hypertension = "Hipertensión"
    case heartDisease = "Cardiopatía"
    case arrhythmia = "Arritmia"
    case none = "Ninguna"
    
    var id: Self { self }
    
    var descr: String {
        switch self {
        case .hypertension: return "Hipertensión"
        case .heartDisease: return "Cardiopatía"
        case .arrhythmia: return "Arritmia"
        case .none: return "Ninguna"
        }
    }
}

// Enum para Nivel de Actividad Física
enum NivelActividad: String, Codable, CaseIterable {
    case high = "Alto"
    case medium = "Medio"
    case low = "Bajo"
    case none = "Ninguna actividad"
    
    var id: Self { self }
    
    var descr: String {
        switch self {
        case .high: return "Alto"
        case .medium: return "Medio"
        case .low: return "Bajo"
        case .none: return "Ninguna actividad"
        }
    }
}
