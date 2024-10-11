//
//  MapView.swift
//  MapKitApp
//
//  Created by Rafael Alejandro Rivas González on 09/10/24.
//

import SwiftUI
import MapKit

struct MapViewComponent: View {
    @State private var position = MapCameraPosition.automatic
    @Binding var searchResults: [SearchResult]
    @State private var selectedLocation: SearchResult?
    @State private var scene: MKLookAroundScene?
    @Binding var viewModel:MapViewModel

        var body: some View {
            VStack {
                Map(position: $position, selection: $selectedLocation) {
                    ForEach(searchResults) { result in
                        Marker(coordinate: result.location) {
                            Image(systemName: "mappin")
                        }
                            .tag(result)
                    }
                }
                
                .ignoresSafeArea()
                
                .onChange(of: selectedLocation) {
                    if let location = selectedLocation {
                        withAnimation {
                            position = .region(MKCoordinateRegion(
                                center: location.location,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            ))
                        }
                        
                    }
                }
                
                .onChange(of: searchResults) {
                    if let firstResult = searchResults.first, searchResults.count == 1 {
                        selectedLocation = firstResult
                    } else if !searchResults.isEmpty {
                        _ = searchResults.map { $0.location }
                        
                    }
                }
                
            }
            
            
        }
}

