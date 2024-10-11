//
//  ReportView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct ReportView: View {
    @State private var selectedSegment = 0 // Selecciona REPORTE / FORO
    var body: some View {
        VStack{
            VStack{
                Picker("Selecciona una opción", selection: $selectedSegment) {
                    Text("Reporte").tag(0)
                    Text("Foro").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if(selectedSegment == 0){
                    PhotoView()
                        .padding(.top,15)
                }
                else {
                    ForoView()
                        .padding(.top,15)
                    
                }
            }
        }.padding(.horizontal)
    }
}

#Preview {
    ReportView()
}
