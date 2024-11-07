//
//  AirQualitySheetViewModel.swift
//  HealthWind
//
//  Created by Leonardo González on 06/11/24.
//

import Foundation
import Alamofire

class AirQualitySheetViewModel: ObservableObject {
    @Published var airQualityCompleteInformation: AirQualityData?
    
    let url = "https://airquality.googleapis.com/v1/currentConditions:lookup?key="
    
    func fetchAirQualityData(latitude: Double, longitude: Double) {
        
        let parameters: [String: Any] = [
            "universalAqi": true,
            "location": [
                "latitude": latitude,
                "longitude": longitude
            ],
            "extraComputations": [
                "HEALTH_RECOMMENDATIONS",
                "DOMINANT_POLLUTANT_CONCENTRATION",
                "POLLUTANT_CONCENTRATION",
                "LOCAL_AQI",
                "POLLUTANT_ADDITIONAL_INFO"
            ],
            "languageCode": "es"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .validate(statusCode: 200..<300)
        .responseDecodable(of: AirQualityData.self) { response in
            switch response.result {
            case .success(let value):
                // Manejo de respuesta exitosa
                print("Respuesta recibida: \(value)")
                DispatchQueue.main.async {
                    self.airQualityCompleteInformation = value
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")

                if let data = response.data, let errorResponse = String(data: data, encoding: .utf8) {
                    print("Respuesta de error: \(errorResponse)")
                }
            }
        }
    }
}
