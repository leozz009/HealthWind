//
//  PhotoDetailView.swift
//  HealthWind
//
//  Created by Julieta Lozano on 06/11/24.
//

import SwiftUI

struct PhotoDetailView: View {
    var image: UIImage
    @State private var description: String = ""
    @State private var isPosting: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if let cgImage = image.cgImage {
                let sRGBImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
                
                Image(uiImage: sRGBImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding()
            }
            
            TextField("Añade una descripción", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                isPosting = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    createPost(description: description, selectedImage: image) {
                        isPosting = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text(isPosting ? "Publicando..." : "Ver detalles")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isPosting ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(isPosting || description.isEmpty)
            
            Spacer()
        }
        .navigationTitle("Detalles de la Foto")
        .navigationBarTitleDisplayMode(.inline)
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
            
            // Perform UI updates on the main thread
            DispatchQueue.main.async {
                if let data = data, let response = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Post creado exitosamente: \(response)")
                    completion()
                }
            }
        }.resume()
    }
}
