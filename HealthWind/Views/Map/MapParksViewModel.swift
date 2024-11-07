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
    
    func fetchAirQualityIndex(place: Place) {
        let url = "https://airquality.googleapis.com/v1/currentConditions:lookup?key="
        // Configura los parámetros
        let parameters: [String: Any] = [
            "location": [
                "latitude": place.location.latitude,
                "longitude": place.location.longitude
            ],
            "languageCode": "es"
        ]
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .validate(statusCode: 200..<300)
        .responseDecodable(of: AirQualityResponse.self) { response in
            switch response.result {
            case .success(let value):
                // Manejo de respuesta exitosa
                print("Respuesta recibida: \(value)")
                DispatchQueue.main.async {
                    let AQIIndex = value.indexes.last
                    self.requestPhoto(name: place.photos[0].name, place: place, AQI: AQIIndex!)
                }
            case .failure(let error):
                // Manejo de error
                print("Error: \(error.localizedDescription)")
                
                // Imprimir detalles adicionales de la respuesta
                if let data = response.data, let errorResponse = String(data: data, encoding: .utf8) {
                    print("Respuesta de error: \(errorResponse)")
                }
            }
        }
    }

    
    func request(latitude: Double, longitude: Double) {
        let url = "https://places.googleapis.com/v1/places:searchNearby"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Goog-Api-Key": "",
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
                    self.fetchAirQualityIndex(place:place)
                     
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func requestPhoto(name: String, place: Place, AQI: AQIIndex){
        let url = "https://places.googleapis.com/v1/\(name)/media?&maxHeightPx=600&maxWidthPx=600"

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                self.locations.append(LocationModel(name: place.displayName.text, coordinate: CLLocationCoordinate2D(latitude: place.location.latitude, longitude: place.location.longitude), image: image!, AQI: AQI))
            case .failure(let error):
                print("Error fetching photo: \(error)")
            }
        }
        
    }
    
}
