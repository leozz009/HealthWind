//
//  ForecastViewModel.swift
//  HealthWind
//
//  Created by Leonardo González on 04/11/24.
//
import Foundation
import Alamofire

class ForecastViewModel: ObservableObject {
    @Published var forecastDataList: [DailyForecast] = []
    
    let url = "https://airquality.googleapis.com/v1/forecast:lookup?key=AIzaSyAu3h_58ZnWB0cHsge_qw69VRGt6tXsG48"
    
    func fetchAirQualityIndexForNextDays(latitude: Double, longitude: Double, daysCount: Int = 4) {
        let calendar = Calendar.current
        let dateFormatter = ISO8601DateFormatter()
        let dispatchGroup = DispatchGroup()
        
        // Limpiamos el array de resultados
        forecastDataList.removeAll()
        
        // Iteramos sobre los días que queremos obtener
        for dayOffset in 1...daysCount {
            dispatchGroup.enter()
            
            // Calcula la fecha para el día actual del ciclo
            guard let futureDate = calendar.date(byAdding: .day, value: dayOffset, to: Date()) else {
                dispatchGroup.leave() // Salimos del grupo si hay un error
                continue
            }
            
            let dateString = dateFormatter.string(from: futureDate)
            
            // Configura los parámetros para cada solicitud
            let parameters: [String: Any] = [
                "location": [
                    "latitude": latitude,
                    "longitude": longitude
                ],
                "dateTime": dateString,
                "languageCode": "es"
            ]
            
            // Realiza la solicitud usando Alamofire
            AF.request(url,
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: WeatherForecast.self) { response in
                switch response.result {
                case .success(let weatherForecast):
                    DispatchQueue.main.async {
                        // Aquí deberías agregar los índices al array forecastDataList
                        if let dailyForecast = weatherForecast.hourlyForecasts.first {
                            self.forecastDataList.append(dailyForecast)
                        }
                    }
                case .failure(let error):
                    print("Error al obtener datos de calidad de aire: \(error.localizedDescription)")
                }
            }
        }
        
        // Esperamos a que todas las solicitudes se completen
        dispatchGroup.notify(queue: .main) {
            print("Todas las solicitudes han sido completadas.")
            // Aquí puedes realizar acciones adicionales una vez que todas las solicitudes hayan finalizado
        }
        
    }
}
