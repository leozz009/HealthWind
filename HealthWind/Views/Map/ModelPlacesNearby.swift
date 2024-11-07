//
//  ModelPlacesNearby.swift
//  MapHealthwind
//
//  Created by Rafael Alejandro Rivas González on 01/11/24.
//

import Foundation
import CoreLocation
import SwiftUI



struct PlacesResponse: Codable {
    let placesArray: [Place]
    
    enum CodingKeys : String, CodingKey {
        case placesArray = "places"
    }
}

struct LocationModel: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let image: UIImage
    let AQI: AQIIndex
}

struct Photo: Codable {
    let heightPx: Int
    let name: String
    let widthPx: Int

}

struct Place: Codable, Identifiable {
    let id: String
    let name: String
    let displayName: DisplayName
    let formattedAddress: String
    let location: Location
    let photos: [Photo]

    struct DisplayName: Codable {
        let text: String
        let languageCode: String
    }

    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
}


