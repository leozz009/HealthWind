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

        
        if(location.name != "" ) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 150, height: 150)
                        .foregroundColor(location.AQI.color.swiftUIColor)
                    
                    Image(uiImage: location.image)
                        .resizable()
                        .frame(width: 140, height: 140)
                        .scaledToFill()
                        .clipShape(Circle())
                }.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                VStack(alignment: .leading) {
                    Text("Calidad del aire")
                        .foregroundColor(.secondary)
                    Text(getLastWordWithCapitalization(text: location.AQI.category))
                        .font(.system(size:30))
                        .foregroundStyle(location.AQI.color.swiftUIColor)
                }
               Spacer()
            }
        }
            
            
    }
}


#Preview {
    ContentView(selectedTab: 1)
}
