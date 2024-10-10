//
//  SheetView.swift
//  MapKitApp
//
//  Created by Rafael Alejandro Rivas González on 09/10/24.
//

import SwiftUI
import MapKit

struct SheetView: View {


    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        
        .padding()

        .presentationDetents([.height(200), .large])
        .presentationBackground(.regularMaterial)
        .interactiveDismissDisabled(true)
        .presentationBackgroundInteraction(.enabled)

    }
}



