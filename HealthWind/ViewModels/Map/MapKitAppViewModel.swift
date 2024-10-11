//
//  MapKitAppViewModel.swift
//  MapKitApp
//
//  Created by Rafael Alejandro Rivas González on 09/10/24.
//
import MapKit
import Combine

@Observable
class MapViewModel: NSObject, MKLocalSearchCompleterDelegate {
    var singleSelection: Bool = false
    private let completer: MKLocalSearchCompleter
    private var searchTask: Task<Void, Never>?
    private var debounceTimer: Timer?
    private let debounceInterval: TimeInterval = 0.5

    var completions = [SearchCompletions]()

    private var cancellable: AnyCancellable?

        init(completer: MKLocalSearchCompleter) {
            self.completer = completer
            super.init()
            self.completer.delegate = self
            self.completer.resultTypes = .pointOfInterest
        }

        func update(queryFragment: String) {
            cancellable?.cancel()
            
            cancellable = Just(queryFragment)
                .delay(for: .seconds(debounceInterval), scheduler: RunLoop.main)
                .sink { [weak self] value in
                    self?.completer.queryFragment = value
                }
        }

        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            completions = completer.results.map { completion in
                _ = completion.value(forKey: "_mapItem") as? MKMapItem
                return .init(
                    title: completion.title,
                    subTitle: completion.subtitle
                )
            }
        }
        
        func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [SearchResult] {
            let mapKitRequest = MKLocalSearch.Request()
            mapKitRequest.naturalLanguageQuery = query
            mapKitRequest.resultTypes = .pointOfInterest
            if let coordinate = coordinate {
                mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
            }
            
            let search = MKLocalSearch(request: mapKitRequest)
            
            let response = try await search.start()
            
            return response.mapItems.compactMap { mapItem in
                guard let location = mapItem.placemark.location?.coordinate else { return nil }
                return .init(location: location)
            }
        }
    

    
    
}
