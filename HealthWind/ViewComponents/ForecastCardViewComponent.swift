//
//  ForecastCardViewComponent.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct ForecastCardViewComponent: View {
    var indice: Int;
    var day: String;
    var body: some View {
        VStack {
            VStack {
                Text("\(indice)")
                    .font(.system(size:200))
                    .minimumScaleFactor(0.01)

                    .foregroundColor(getColorByIndex(indice))
                
            }
            .frame(width: 50, height: 56)
            .padding(.all,8)
            .background(.grayComponent)
            .cornerRadius(12)
            .shadow(color:getColorByIndex(indice),radius: 4)
            
            Text(day)
                .foregroundColor(.secondary)
        }
        
    }
}

// Funcion que verifica el indice y selecciona el color (HAY QUE PONER LOS COLORES ADECUADOS)
func getColorByIndex(_ indice: Int) -> Color {
    switch indice {
    case 0...50:
        return .green  // Buena calidad
    case 51...100:
        return .yellow  // Moderada
    case 101...150:
        return .orange  // Mala
    case 151...200:
        return .red     // Muy mala
    case 201...300:
        return .purple  // Peligrosa
    default:
        return .gray    // Desconocido
    }
}

#Preview {
    ForecastCardViewComponent(indice: 150, day: "Lun")
}
