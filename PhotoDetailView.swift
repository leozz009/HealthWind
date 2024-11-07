import SwiftUI
import CoreML
import Vision

struct PhotoDetailView: View {
    var image: UIImage
    @Environment(\.dismiss) var dismiss
    @State private var classificationResult: String?
    @State private var showingResultSheet = false

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
                        // Show classification result
                        Text(result)
                            .font(.body)
                            .padding()
                        
                        // Buttons displayed after classification is complete
                        HStack {
                            Button("Cerrar") {
                                showingResultSheet = false
                            }
                            .padding()
                            
                            Button("Detalles") {
                                // Placeholder for "Detalles" action, currently does nothing
                            }
                            .padding()
                        }
                    } else {
                        // Show "in process" message if classification is not yet completed
                        Text("Clasificación en proceso...")
                            .font(.body)
                            .padding()
                    }
                }
                .presentationDetents([.fraction(0.25)])
            }
        }
        .navigationTitle("Detalles de la Foto")
        .navigationBarTitleDisplayMode(.inline)
    }

    func classifyImage() {
        // Display the sheet immediately to show the "in process" message
        self.classificationResult = nil
        self.showingResultSheet = true

        // Load the CoreML model with a configuration
        let modelConfiguration = MLModelConfiguration()
        guard let coreMLModel = try? AirPollutionClassifier1(configuration: modelConfiguration).model else {
            print("Failed to load model")
            return
        }
        
        // Ensure the CoreML model is loaded into Vision
        guard let visionModel = try? VNCoreMLModel(for: coreMLModel) else {
            print("Failed to create VNCoreMLModel")
            return
        }
        
        // Create a Vision request for image classification
        let request = VNCoreMLRequest(model: visionModel) { (request, error) in
            if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                DispatchQueue.main.async {
                    // Update the classification result to show in the UI
                    self.classificationResult = topResult.identifier
                }
            } else if let error = error {
                print("Error during classification: \(error)")
            }
        }
        
        // Convert the UIImage to a CGImage
        guard let cgImage = image.cgImage else {
            print("Failed to convert UIImage to CGImage")
            return
        }
        
        // Perform the request on a background queue
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
