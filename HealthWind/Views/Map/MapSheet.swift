//
//  MapSheet.swift
//  MapHealthwind
//
//  Created by Rafael Alejandro Rivas González on 06/11/24.
//

import Foundation
import SwiftUI

public struct MapSheet: View {
    @Binding var location: LocationModel
    public var body: some View {

        
        if(location.name != "") {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 160, height: 160)
                        .foregroundColor(location.AQI.color.swiftUIColor)
                    
                    Image(uiImage: location.image)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaledToFill()
                        .clipShape(Circle())
                }
                VStack {
                    Text("Calidad del aire")
                        .foregroundColor(.secondary)
                    Text(getLastWordWithCapitalization(text: location.AQI.category))
                        .font(.system(size:30))
                        .foregroundStyle(location.AQI.color.swiftUIColor)
                    
                    
                }
                
            }
        }
            
            
    }
}


#Preview {
    ContentView(selectedTab: 1)
}
