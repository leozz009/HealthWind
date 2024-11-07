//
//  Post.swift
//  HealthWind
//
//  Created by Julieta Lozano on 30/10/24.
//

import Foundation

struct Post: Identifiable, Decodable {
    let id: Int
    let nombre: String
    let descripcion: String
    let imagen: String?
    let fecha: String

    // Convertir la fecha a un formato más legible
    var fechaFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: fecha) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return fecha
    }
}

