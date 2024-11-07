import SwiftUI

struct SignupView: View {
    @State private var nombre = ""
    @State private var fotoPerfil = ""
    @State private var correo = ""
    @State private var contraseña = ""
    @State private var mensaje = ""

    var body: some View {
        ZStack {
            BackgroundViewComponent() // Mantén tu componente de fondo

            VStack{
                Spacer()
                HStack {
                    Text("Registro")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }.padding(.bottom,5)
                
                HStack{
                    Text("Regístrate para acceder a esta funcionalidad")
                        .padding(.bottom, 25)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                // Campos de registro
                TextField("Nombre", text: $nombre)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                TextField("URL de Foto de Perfil", text: $fotoPerfil)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                TextField("Correo electrónico", text: $correo)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                SecureField("Contraseña", text: $contraseña)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                Button(action: {
                    // Llamada a la función de registro
                    signUpUser(nombre: nombre, foto_perfil: fotoPerfil, correo: correo, contraseña: contraseña) { response in
                        DispatchQueue.main.async {
                            mensaje = response
                        }
                    }
                }) {
                    Text("Registrarse")
                        .bold()
                        .padding()
                        .background(Color.blueApp) // Asegúrate de tener este color definido
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top,8)
                }
                .padding(.bottom, 10)
                
                // Mostrar mensaje después del registro
                Text(mensaje)
                    .padding()
                    .foregroundColor(mensaje.contains("exitosamente") ? .green : .red)
                
                Spacer()
            }
            .padding()
            .padding()
        }
    }
}

func signUpUser(nombre: String, foto_perfil: String, correo: String, contraseña: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: "http://10.22.234.107:3000/signup") else {
        completion("URL inválida")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let usuarioData: [String: Any] = [
        "nombre": nombre,
        "foto_perfil": foto_perfil,
        "correo": correo,
        "contraseña": contraseña
    ]

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: usuarioData, options: [])
        request.httpBody = jsonData
    } catch {
        completion("Error al crear el JSON")
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion("Error en la solicitud: \(error.localizedDescription)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            completion("Error en la respuesta del servidor")
            return
        }

        completion("Usuario registrado exitosamente")
    }
    task.resume()
}

#Preview {
    SignupView()
}
