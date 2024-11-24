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
    public let id = UUID()
    public let name: String
    public let coordinate: CLLocationCoordinate2D
    public let image: UIImage
    public let AQI: AQIIndex
}

 struct Photo: Codable {
    let heightPx: Int
    let name: String
    let widthPx: Int

}

 struct Place: Codable, Identifiable {
    public let id: String
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


