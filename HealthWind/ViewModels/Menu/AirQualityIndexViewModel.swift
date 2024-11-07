//
//  AirQualityIndexViewModel.swift
//  HealthWind
//
//  Created by Leonardo González on 01/11/24.
//
import Foundation
import Alamofire

class AirQualityIndexViewModel: ObservableObject{
    
    @Published var airQualityData: AirQualityResponse?
    
    let url = ""
    
    func fetchAirQualityIndex(latitude: Double, longitude: Double) {
        // Configura los parámetros
        let parameters: [String: Any] = [
            "location": [
                "latitude": latitude,
                "longitude": longitude
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
                    self.airQualityData = value
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
}
