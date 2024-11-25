import SwiftUI
import CoreML
import Vision

struct PhotoDetailView: View {
    var image: UIImage
    @Environment(\.dismiss) var dismiss
    @State private var classificationResult: String?
    @State private var showingResultSheet = false

    // Traducción para que se vea mejor
    let labelTranslations: [String: String] = [
        "a_Good": "Bueno",
        "b_Moderate": "Moderado",
        "c_Unhealthy_for_Sensitive_Groups": "Dañino para grupos sensibles",
        "d_Unhealthy": "Dañino",
        "e_Very_Unhealthy": "Muy dañino",
        "f_Severe": "Severo"
    ]

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

            Button(action: classifyImage) {
                Text("Analizar")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            .sheet(isPresented: $showingResultSheet) {
                VStack {
                    Text("Resultado de la Clasificación")
                        .font(.headline)
                        .padding()
                    
                    if let result = classificationResult {
                        // Mostrar resultado
                        Text("El cielo parece ser \(result), revisa el apartado de salud para recomendaciones.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()

                        // Small disclaimer
                        Text("La IA puede cometer errores, comprueba la información.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                        
                        
                        HStack {
                            Button("Cerrar") {
                                showingResultSheet = false
                            }
                            .padding()
                            
                            Button("Publicar") {
                                // No hace nada, Juntar con lo de Julieta
                            }
                            .padding()
                        }
                    } else {
                        
                        Text("Clasificación en proceso...")
                            .font(.body)
                            .padding()
                    }
                }
                .presentationDetents([.fraction(0.3)])
            }
        }
        .navigationTitle("Detalles de la Foto")
        .navigationBarTitleDisplayMode(.inline)
    }

    func classifyImage() {
        
        self.classificationResult = nil
        self.showingResultSheet = true

        
        let modelConfiguration = MLModelConfiguration()
        guard let coreMLModel = try? AirPollutionClassifier1(configuration: modelConfiguration).model else {
            print("Failed to load model")
            return
        }
        
    
        guard let visionModel = try? VNCoreMLModel(for: coreMLModel) else {
            print("Failed to create VNCoreMLModel")
            return
        }
        
        
        let request = VNCoreMLRequest(model: visionModel) { (request, error) in
            if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                DispatchQueue.main.async {
                    
                    let translatedLabel = self.labelTranslations[topResult.identifier] ?? "Desconocido"
                    self.classificationResult = translatedLabel
                }
            } else if let error = error {
                print("Error during classification: \(error)")
            }
        }
        
        
        guard let cgImage = image.cgImage else {
            print("Failed to convert UIImage to CGImage")
            return
        }
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
}
