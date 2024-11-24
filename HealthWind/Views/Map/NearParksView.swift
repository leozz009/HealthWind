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
    @State var location: LocationModel = .init(name: "", coordinate: .init(latitude: 0, longitude: 0), image: UIImage(systemName: "apple.meditate")!, AQI: AQIIndex(code: "", displayName: "", aqi: 0, aqiDisplay: "", color: AQIColor(red: 0, green: 0, blue: 0), category: "", dominantPollutant: ""))
    @State private var showSwiftUIMap = 0
    
    var body: some View {
        ZStack {
            Picker(selection: $showSwiftUIMap, label: Text("Map Type")) {
                Text("Mapa de calor").tag(0)
                Text("Areas verdes").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            .zIndex(1)
            .foregroundStyle(.primary)
            .padding(.bottom, 650)
            
            MapParksView(locationViewModel: $locationViewModel,
                        showSwiftUIMap: $showSwiftUIMap,
                        location: $location)
        }
        .modifier(ConditionalBottomSheet(
            showSheet: showSwiftUIMap == 1,
            bottomSheetPosition: $bottomSheetPosition,
            location: $location
        ))
    }
}

// Create a custom ViewModifier to handle the conditional bottom sheet
struct ConditionalBottomSheet: ViewModifier {
    let showSheet: Bool
    @Binding var bottomSheetPosition: BottomSheetPosition
    @Binding var location: LocationModel
    
    func body(content: Content) -> some View {
        if showSheet {
            content.bottomSheet(
                bottomSheetPosition: $bottomSheetPosition,
                switchablePositions: [.relative(0.2), .relative(0.4)],
                title: location.name
            ) {
                MapSheet(location: $location)
            }
        } else {
            content
        }
    }
}

#Preview {
    ContentView(selectedTab: 1)
}


