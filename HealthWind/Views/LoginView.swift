//
//  LoginView.swift
//  HealthWind
//
//  Created by Leonardo González on 17/10/24.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        @State var email: String = ""
        @State var password: String = ""
        ZStack {
            BackgroundViewComponent()
            VStack{
                Spacer()
                HStack {
                    Text("Iniciar sesión")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }.padding(.bottom,5)
                
                HStack{
                    Text("Debes iniciar sesión para tener acceso a está funcionalidad")
                        .padding(.bottom, 25)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
    
                TextField("Correo electrónico", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                Button(action: {
                    // Code
                }) {
                    Text("Iniciar Sesión")
                        .bold()
                        .padding()
                        .background(Color.blueApp)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top,8)
                }
                Spacer()
            }.padding().padding()
        }
    }
}

#Preview {
    LoginView()
}
