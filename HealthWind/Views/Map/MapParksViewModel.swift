//
//  MapParksViewModel.swift
//  MapHealthwind
//
//  Created by Rafael Alejandro Rivas González on 01/11/24.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftUI
class MapParksViewModel: ObservableObject {
    
    @Published var places: [Place] = []
    @Published var isLoading: Bool = true
    @Published var locations: [LocationModel] = []
    @Published var reponse: String?
    
    func request(latitude: Double, longitude: Double) {
        let url = "https://places.googleapis.com/v1/places:searchNearby"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Goog-Api-Key": "AIzaSyAu3h_58ZnWB0cHsge_qw69VRGt6tXsG48",
            "X-Goog-FieldMask" : "*"
        ]

        let jsonBody: [String: Any] = [
            "includedTypes": ["park"],
            "maxResultCount": 15,
            "locationRestriction": [
                "circle": [
                    "center": [
                        "latitude": latitude,
                        "longitude": longitude
                    ],
                    "radius": 20000
                ]
            ],
            "rankPreference": "POPULARITY",
            "languageCode": "es"
        ]

        AF.request(url, method: .post, parameters: jsonBody, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: PlacesResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                self.places = apiResponse.placesArray
                for place in self.places {
                    self.requestPhoto(name: place.photos[0].name, place: place)
                    
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func requestPhoto(name: String, place: Place){
        let url = "https://places.googleapis.com/v1/\(name)/media?key=AIzaSyAu3h_58ZnWB0cHsge_qw69VRGt6tXsG48&maxHeightPx=600&maxWidthPx=600"

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                self.locations.append(LocationModel(name: place.displayName.text, coordinate: CLLocationCoordinate2D(latitude: place.location.latitude, longitude: place.location.longitude), image: image!))
            case .failure(let error):
                print("Error fetching photo: \(error)")
            }
        }
        
    }
    
}
