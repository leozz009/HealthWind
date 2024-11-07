//
//  AuthViewModel.swift
//  HealthWind
//
//  Created by Julieta Lozano on 18/10/24.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = true  // Estado de sesión
    @Published var hasLoggedInBefore: Bool = true // Para saber si ya inició sesión antes
    
    // Función de inicio de sesión
    func login() {
        isAuthenticated = true
        hasLoggedInBefore = true
    }
    
    // Función de cierre de sesión
    func logout() {
        isAuthenticated = false
    }
}
