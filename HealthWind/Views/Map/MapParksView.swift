import SwiftUI
import MapKit

struct MapParksView: View {
    @Binding var locationViewModel: LocationViewModel
    @StateObject private var mapParksViewModel = MapParksViewModel()
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                           span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    )
    @Binding var showSwiftUIMap: Int
    @Binding var location: LocationModel

    var body: some View {
        VStack {
            
            

            if (showSwiftUIMap != 0) {
                // SwiftUI Map
                Map(position: $position) {
                    ForEach(mapParksViewModel.locations) { places in
                        Annotation(places.name, coordinate: places.coordinate) {
                            ZStack {
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
                            }
                            .onTapGesture {
                                location = places
                            }
                        }
                    }
                }
                .onAppear {
                    updateCameraPosition()
                }
                .onMapCameraChange { newCamera in
                    if mapParksViewModel.places.isEmpty {
                        mapParksViewModel.request(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude)
                    }
                }
            } else {
                // UIKit Map with Tiles
                CustomMapView(
                    locationViewModel: $locationViewModel,
                    selectedLocation: $location,
                    mapParksViewModel: mapParksViewModel
                ).edgesIgnoringSafeArea(.top)
            }
        }
    }

    private func updateCameraPosition() {
        position = MapCameraPosition.region(
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude),
                               span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        )
    }
}

// MARK: - Representable for UIKit Map with Tiles
struct CustomMapView: UIViewRepresentable {
    @Binding var locationViewModel: LocationViewModel
    @Binding var selectedLocation: LocationModel
    @ObservedObject var mapParksViewModel: MapParksViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Configure initial region
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        mapView.setRegion(initialRegion, animated: false)

        // Add tile overlay
        let tileOverlay = MKTileOverlay(urlTemplate: "https://airquality.googleapis.com/v1/mapTypes/UAQI_RED_GREEN/heatmapTiles/{z}/{x}/{y}?key=AIzaSyAu3h_58ZnWB0cHsge_qw69VRGt6tXsG48")
        tileOverlay.canReplaceMapContent = false
        mapView.addOverlay(tileOverlay)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map region
        let updatedRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        uiView.setRegion(updatedRegion, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(_ parent: CustomMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                let renderer = MKTileOverlayRenderer(tileOverlay: tileOverlay)
                renderer.alpha = 0.8 // Set opacity here (0.0 to 1.0)
                return renderer
            }
            return MKOverlayRenderer()
        }
    }

}

