//
//  HealthWindApp.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

@main
struct HealthWindApp: App {
    @StateObject var mapParksViewModel = MapParksViewModel()
    let appDependencies = AppDependencies.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mapParksViewModel)
                .environmentObject(appDependencies.airQualityViewModel)
        }
    }
}
