//
//  MapParksView.swift
//  MapHealthwind
//
//  Created by Rafael Alejandro Rivas González on 06/11/24.
//

import SwiftUI
import MapKit
struct MapParksView: View {
    @Binding var locationViewModel: LocationViewModel
    @StateObject private var mapParksViewModel = MapParksViewModel()
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    @State private var sheetPresented: Bool = true
    @Binding var location: LocationModel
    var body: some View {
        
        
        VStack {
            Map(position: $position){
                ForEach(mapParksViewModel.locations){ places in
                    Annotation(places.name, coordinate: places.coordinate) {
                        ZStack{
                            
                            Circle()
                                .fill(places.AQI.color.swiftUIColor)
                                .opacity(0.2)
                                .frame(width: 38, height: 38)
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 29, height: 29)
                            
                            Image(systemName: "leaf.fill")
                                .resizable()
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                                .frame(width: 25, height: 25)
                                .background(places.AQI.color.swiftUIColor)
                                .clipShape(.circle)
                            
                        }.onTapGesture {
                            location = places
                        }
                        
                        
                    }
                    
                }
                
            }.onMapCameraChange { newCamera in
                if(mapParksViewModel.places.isEmpty){
                    mapParksViewModel.request(latitude: locationViewModel.latitude,longitude: locationViewModel.longitude)
                }
            }
        }.onAppear {
            
            position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
        }
        .onChange(of: locationViewModel.latitude) {
            updateCameraPosition()
        }
        .onChange(of: locationViewModel.longitude) {
            updateCameraPosition()
        }
        
    }
    private func updateCameraPosition(){
        position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    }
    
}
