import SwiftUI

struct PhotoView: View {
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var navigateToDetail = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center) {
                    Text("¿Qué estás observando?")
                        .font(.title)
                        .padding(.bottom, 10)
                    Text("Toma una foto para generar un reporte de la contaminación actual en la zona en la que estás")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    ZStack {
                        Image(systemName: "circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .font(.system(size: 10, weight: .thin))
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .font(.system(size: 10, weight: .bold))
                            .onTapGesture {
                                showingImagePicker = true
                            }
                    }
                    .foregroundColor(.secondary)
                    .sheet(isPresented: $showingImagePicker, onDismiss: {
                        if selectedImage != nil {
                            navigateToDetail = true
                        }
                    }) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                }
                .padding(.top, 80)
                
                Spacer()
            }
            .navigationDestination(isPresented: $navigateToDetail) {
                if let image = selectedImage {
                    PhotoDetailView(image: image)
                }
            }
        }
    }
}
