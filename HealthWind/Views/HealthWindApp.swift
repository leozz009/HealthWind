//
//  HealthWindApp.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI
import SwiftData

@main
struct HealthWindApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
