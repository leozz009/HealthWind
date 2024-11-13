import SwiftUI

struct PostViewComponent: View {
    // Variables que entran como parámetro en el componente
    var profileImage: Image
    var name: String
    var date: String
    var description: String
    var reportImageURL: String? // Ahora recibimos la URL de la imagen en lugar de un objeto Image
    
    // Variables necesarias para que los símbolos se mantengan presionados
    @State private var isLiked = false
    @State private var isShared = false
    @State private var isCommented = false
    
    var body: some View {
        VStack {
            HStack {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                Text(name)
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.blue)
                Spacer()
                Text(date)
                    .foregroundColor(.secondary)
                    .fontWeight(.light)
            }.padding(.bottom, 8)
            
            VStack {
                Text(description).foregroundColor(.secondary)
                
                // AsyncImage para cargar la imagen desde una URL solo si reportImageURL es válido
                if let reportImageURL = reportImageURL, !reportImageURL.isEmpty, let url = URL(string: reportImageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView() // Puedes mostrar un indicador de carga en lugar de un marcador de posición si lo prefieres
                    }
                }
            }
            
            HStack {
                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                        .font(.system(size: 20))
                }
                
                Button(action: {
                    isCommented.toggle()
                }) {
                    Image(systemName: isCommented ? "bubble.right.fill" : "bubble.right")
                        .foregroundColor(isCommented ? .green : .gray)
                        .font(.system(size: 20))
                }
                Spacer()
                
                Button(action: {
                    isShared.toggle()
                }) {
                    Image(systemName: isShared ? "square.and.arrow.up.fill" : "square.and.arrow.up")
                        .foregroundColor(isShared ? .blue : .gray)
                        .font(.system(size: 20))
                }
            }.padding(.top, 3)
             .padding(.bottom, 5)
        }
        .padding(.top, 10)
    }
}

#Preview {
    PostViewComponent(
        profileImage: Image("profileImage"),
        name: "Aracely Salinas",
        date: "10 Oct",
        description: "Hay reportes de contaminación en la zona urbana de Monterrey. Se recomienda no salir para evitar riesgos en la salud.",
        reportImageURL: nil // Cambia este valor para probar el comportamiento sin imagen
    )
}
