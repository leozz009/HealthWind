import SwiftUI
import PhotosUI

struct NewPostView: View {
    @Binding var isPresented: Bool
    @State private var postText: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var imageSelection: PhotosPickerItem? = nil
    @State private var isPosting: Bool = false // Estado para deshabilitar el botón mientras se publica

    var body: some View {
        NavigationView {
            VStack {
                // Área de texto para el post
                TextEditor(text: $postText)
                    .frame(height: 100)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Picker para la imagen
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                        .padding()
                } else {
                    PhotosPicker(selection: $imageSelection, matching: .images) {
                        Text("Seleccionar imagen")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .onChange(of: imageSelection) {
                        if let imageSelection {
                            Task {
                                if let data = try? await imageSelection.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }
                    }

                }
                
                Spacer()

                // Botón para publicar
                Button(action: {
                    isPosting = true
                    createPost(description: postText, selectedImage: selectedImage) {
                        isPosting = false
                        isPresented = false
                    }
                }) {
                    Text(isPosting ? "Publicando..." : "Publicar")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isPosting ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(isPosting || postText.isEmpty)


            }
            .navigationTitle("Nuevo Post")
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }) {
                Text("Cancelar")
            })
        }
    }

    func createPost(description: String, selectedImage: UIImage?, completion: @escaping () -> Void) {
        let usuarioID = 2 // ID del usuario es 2
        guard let url = URL(string: "http://10.22.233.131:3000/posts") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()

        // Agregar el ID del usuario
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"usuario_id\"\r\n\r\n".utf8))
        body.append(Data("\(usuarioID)\r\n".utf8))

        // Agregar la descripción
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"descripcion\"\r\n\r\n".utf8))
        body.append(Data("\(description)\r\n".utf8))

        // Agregar la imagen si existe
        if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            let filename = "image.jpg"
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"imagen\"; filename=\"\(filename)\"\r\n".utf8))
            body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
            body.append(imageData)
            body.append(Data("\r\n".utf8))
        } else {
            print("No se seleccionó ninguna imagen")
        }

        // Terminar el cuerpo de la solicitud
        body.append(Data("--\(boundary)--\r\n".utf8))

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al crear el post: \(error)")
                return
            }
            if let data = data, let response = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Post creado exitosamente: \(response)")
                completion()
            }
        }.resume()
    }


}

#Preview {
    NewPostView(isPresented: .constant(true))
}
