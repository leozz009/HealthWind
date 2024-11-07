
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedTab: Int  // Binding para cambiar de pestaña
    @State var email: String = ""
    @State var password: String = ""
    @State var mensaje: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {  // Asegúrate de envolver en NavigationView
            ZStack {
                BackgroundViewComponent()

                VStack {
                    Spacer()
                    HStack {
                        Text("Iniciar sesión")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }.padding(.bottom, 5)

                    HStack {
                        Text("Debes iniciar sesión para tener acceso a esta funcionalidad")
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
                        iniciarSesion(email: email, password: password) { resultado in
                            DispatchQueue.main.async {
                                if resultado == "Inicio de sesión exitoso" {
                                    authViewModel.login()
                                    presentationMode.wrappedValue.dismiss()  // Cerrar la vista de login
                                    // Cambiar a la pestaña deseada
                                    if authViewModel.hasLoggedInBefore {
                                        selectedTab = 3  // Redirigir a "Salud" por ejemplo
                                    } else {
                                        selectedTab = 4  // Redirigir a "Perfil" si es el caso
                                    }
                                } else {
                                    mensaje = resultado
                                }
                            }
                        }
                    }) {
                        Text("Iniciar Sesión")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blueApp)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 8)
                    }

                    if !mensaje.isEmpty {
                        Text(mensaje)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    NavigationLink(destination: SignupView()) {  // Enlace para navegar a la vista de Signup
                        Text("Crear cuenta")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blueSecundaryApp)
                            .cornerRadius(8)
                            .padding(.top,8)
                    }

                    Spacer()
                }
                .padding()
                .padding()
            }
        }
    }
}

// Función para iniciar sesión con el servidor
func iniciarSesion(email: String, password: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: "https://healthwindapi.vercel.app/login") else {
        completion("URL inválida")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let parametros: [String: Any] = [
        "correo": email,
        "contrasenia": password
    ]

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parametros, options: [])
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

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion("Correo o contraseña incorrectos")
            return
        }

        completion("Inicio de sesión exitoso")
    }
    task.resume()
}

#Preview {
    LoginView(selectedTab: .constant(0))
}
