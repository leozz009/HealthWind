import SwiftUI
import PhotosUI

struct SignupView: View {
    @State private var nombre = ""
    @State private var fotoPerfilBase64 = ""
    @State private var correo = ""
    @State private var contraseña = ""
    @State private var mensaje = ""
    @State private var isLoading = false
    
    @State private var selectedImage: UIImage? = nil
    @State private var imageSelection: PhotosPickerItem? = nil

    var body: some View {
        ZStack {
            BackgroundViewComponent()
    
            VStack {
                Spacer()
                HStack {
                    Text("Registro")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }.padding(.bottom, 5)
                
                HStack {
                    Text("Regístrate para acceder a esta funcionalidad")
                        .padding(.bottom, 25)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                PhotosPicker(selection: $imageSelection, matching: .images) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blueApp, lineWidth: 6))
                            .shadow(radius: 6)
                            .padding(.bottom,20)
                        
                    } else {
                        VStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 170, height: 170)
                                .clipShape(Circle())
                                
                                .foregroundStyle(.grayPhoto)
                                .padding(.bottom,12)
                            
                            Text("Presiona para agregar tu foto")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 20)
                    }
                }
                .onChange(of: imageSelection) { _ in
                    processSelectedImage()
                }
                
                // Campos de registro
                TextField("¿Cómo te gusta que te llamen?", text: $nombre)
                    .autocapitalization(.words)
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
                
                // Botón de registro
                Button(action: {
                    guard validarFormulario() else { return }
                    isLoading = true
                    signUpUser(nombre: nombre, foto_perfil: fotoPerfilBase64, correo: correo, contraseña: contraseña) { response in
                        DispatchQueue.main.async {
                            mensaje = response
                            isLoading = false
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.blueApp)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Text("Registrarse")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .bold()
                            .padding()
                            .background(Color.blueApp)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom)
                
                // Mostrar mensaje después del registro
                Text(mensaje)
                    .padding()
                    .foregroundColor(mensaje.contains("exitosamente") ? .green : .red)
                
                Spacer()
            }.padding()
            .padding()
        }
    }
    
    // Validar formulario
    func validarFormulario() -> Bool {
        if nombre.isEmpty || correo.isEmpty || contraseña.isEmpty || fotoPerfilBase64.isEmpty {
            mensaje = "Todos los campos son obligatorios"
            return false
        }
        if !correo.contains("@") {
            mensaje = "Correo electrónico no válido"
            return false
        }
        return true
    }

    // Procesar imagen seleccionada
    func processSelectedImage() {
        if let item = imageSelection {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.selectedImage = image
                            self.fotoPerfilBase64 = data.base64EncodedString()
                        }
                    }
                case .failure(let error):
                    print("Error al cargar la imagen: \(error.localizedDescription)")
                }
            }
        }
    }

    // Enviar datos al servidor
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

            guard let httpResponse = response as? HTTPURLResponse else {
                completion("Respuesta inválida del servidor")
                return
            }

            switch httpResponse.statusCode {
            case 200...299:
                completion("Usuario registrado exitosamente")
            case 400:
                completion("Error: Verifica tus datos")
            case 500:
                completion("Error del servidor. Intenta más tarde.")
            default:
                completion("Error desconocido. Código: \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
}

#Preview {
    SignupView()
}
