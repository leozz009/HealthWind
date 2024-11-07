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
        Text(location.name)
            .font(.largeTitle)
        Image(uiImage: location.image)
            .resizable()
            .frame(width: 100, height: 100)
            .scaledToFill()
            
            
    }
}

#Preview {
    ContentView(selectedTab: 1)
}
