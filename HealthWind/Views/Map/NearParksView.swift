//
//  NearParksView.swift
//  MapHealthwind
//
//  Created by Rafael Alejandro Rivas González on 01/11/24.
//

import SwiftUI
import MapKit

struct NearParksView: View {

    @State private var sheetPresented: Bool = true
    var body: some View {
        
        ZStack {
            MapParksView()
        }.sheet(isPresented: $sheetPresented) {
            MapSheet()
        }
        
    }
}

#Preview {
    NearParksView()
}
