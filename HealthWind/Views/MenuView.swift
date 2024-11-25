//
//  MenuView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct MenuView: View {
    @State private var showingSheet = false
    @StateObject private var airQualityIndex = AirQualityIndexViewModel()
    @StateObject private var forecast = ForecastViewModel()
    @StateObject private var airPolutionDetails = AirQualitySheetViewModel()
    
    var body: some View {
        ZStack {
            BackgroundViewComponent()  // Componente de fondo
            // Saludo y profile image
            VStack {
                HStack {
                    Text("Bienvenido")
                        .font(.title)
                        .foregroundColor(.white)
                        
                    Spacer()
                    Circle()
                        .frame(width: 50)
                        .foregroundColor(.white)
                }.padding(.top,50)
                
                // Imagen de la nube y texto descriptivo
                VStack{
                    Text("🌥️")
                        .font(.system(size: 125))
                    VStack {
                        Text("Parcialmente Nublado")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.gray)
                            
                        Text(formattedCurrentDate())
                            .font(.title3)
                            .foregroundColor(.gray)
                    }.padding(.bottom,10)
                }.padding().offset(y:-20)
                
                // Ubicación, Calidad del aire y contaminantes
                VStack {
                    HStack{
                        Text("Monterrey, Nuevo León")
                            .font(.title2)
                        Spacer()
                    }.padding(.bottom,5)
                    
                    HStack{
                        Text("Calidad del aire")
                            .foregroundColor(.secondary)
                        Spacer()
                    }.offset(y:15)
                    HStack{
                        Text("\(airPolutionDetails.airQualityCompleteInformation?.indexes.last?.category ?? "")")
                            .font(.system(size:60))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(airPolutionDetails.airQualityCompleteInformation?.indexes.last?.color.colorforSwiftUI ?? .gray)
                        
                        Spacer()
                        VStack(alignment:.trailing){
                            Text("Índice de calidad: \(airQualityIndex.airQualityData?.indexes.first?.aqi ?? 0)")
                                .padding(.all,5)
                                .background(airQualityIndex.airQualityData?.indexes.first?.color.swiftUIColor ?? .gray)
                                .cornerRadius(8)
                                .opacity(0.5)
                            Text(getWordUppercase(text: airQualityIndex.airQualityData?.indexes.first?.dominantPollutant ?? ""))
                                .foregroundColor(.white)
                                .padding(.all,5)
                                .background(.gray)
                                .cornerRadius(8)
                        }.font(.caption)
                    }
                }.padding(.bottom,5)
                
                // Pronóstico semanal -> Deslizamiento
                
                VStack{
                    HStack{
                        Text("Pronóstico de los siguientes días")
                            .foregroundColor(.secondary)
                        Spacer()
                    }.padding(.bottom,10)
                    HStack(spacing: 16) {
                        let today = Date()
                        let calendar = Calendar.current
                        
                        // Crear las fechas para los próximos días
                        let daysOffset = [1, 2, 3, 4]
                        let dates = daysOffset.map { calendar.date(byAdding: .day, value: $0, to: today)! }
                        
                        // Formateador de fecha
                        let dayFormatter: DateFormatter = {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "EEE" // Formato de día abreviado
                            formatter.locale = Locale(identifier: "es_ES") // Configura el idioma a español
                            return formatter
                        }()
                        
                        // Crear los componentes ForecastCardViewComponent dinámicamente
                        ForEach(0..<forecast.forecastDataList.count, id: \.self) { index in
                            // Verificar si el índice es válido y existe
                            if index < forecast.forecastDataList.count {
                                let forecastDay = forecast.forecastDataList[index]
                                
                                // Obtener el día correspondiente de la lista de fechas
                                let date = dates[index]
                                
                                // Formatear el día y obtener el color
                                let formattedDay = capitalizedFirstLetter(dayFormatter.string(from: date))
                                let color = forecastDay.indexes.first?.color.swiftUIColor ?? .gray
                                let aqi = forecastDay.indexes.first?.aqi ?? 0
                                
                                // Crear el componente
                                ForecastCardViewComponent(
                                    indice: aqi,
                                    day: formattedDay,
                                    color: color
                                )
                            }
                        }
                    }
                    .padding(.all, 5)
                    .frame(height: 110)
                }
                
                // Botón para ir al detalle actual
                
                VStack{
                    Button("Ver detalle actual"){
                        showingSheet.toggle()
                    }.buttonStyle(.borderedProminent)
                        .tint(.blueApp)
                }
                .padding(.top, 20)
                .sheet(isPresented: $showingSheet){
                    DetailSheetView()
                        .presentationDetents([.height(650)])
                }
                Spacer()
            }
            .padding(.horizontal,25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Llama a la función para obtener los datos de la calidad del aire
            if(!airQualityIndex.loaded){
                airQualityIndex.fetchAirQualityIndex(latitude: 25.6866, longitude: -100.3161)
            }
                
            
            if(!airPolutionDetails.loaded){
                airPolutionDetails.fetchAirQualityData(latitude: 25.6866, longitude: -100.3161)
            }
            if(!forecast.loaded){
                forecast.fetchAirQualityIndexForNextDays(latitude: 25.6866, longitude: -100.3161)
            }
            
            
            
        }
    }
    
    // Funciones necesarias para el funcionamiento de la pantalla
    
    func formattedCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES") // Español, puede cambiair
        formatter.dateStyle = .full // Incluye día, fecha y año
        
        let dateString = formatter.string(from: Date())
        return dateString.prefix(1).uppercased() + dateString.dropFirst()
    }
    
    func getLastWordWithCapitalization(text: String) -> String {
        let words = text.components(separatedBy: " ")
        guard let lastWord = words.last else { return "" }
    
        return lastWord.capitalized // Poner en mayuscula la última palabra
    }
    
    func getWordUppercase(text: String) -> String {
        return text.uppercased()
    }
    
    func capitalizedFirstLetter(_ string: String) -> String {
        return string.prefix(1).capitalized + string.dropFirst()
    }
}

#Preview {
    MenuView()
}
