//
//  NearParksView.swift
//  MapHealthwind
//
//  Created by Rafael Alejandro Rivas González on 01/11/24.
//

import SwiftUI
import MapKit
import BottomSheet

struct MapView: View {
    
    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.2)
    @Binding var locationViewModel: LocationViewModel
    @State var location: LocationModel = .init(name: "", coordinate: .init(latitude: 0, longitude: 0), image: UIImage(systemName: "apple.meditate")!)
    var body: some View {
        
        ZStack {
            MapParksView(locationViewModel: $locationViewModel, location: $location)
        }.bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, switchablePositions: [.relative(0.2), .relative(0.4), .relative(0.6)], title: location.name){
            MapSheet(location: $location)
            
        }
    }
}

#Preview {
    ContentView(selectedTab: 1)
}


