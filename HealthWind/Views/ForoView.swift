import SwiftUI

struct ForoView: View {
    @State private var isPresentingNewPostView = false // Variable para manejar el modal
    @State private var posts: [Post] = [] // Aquí almacenamos los posts obtenidos de la API
    @State private var isLoading = true // Indicador de carga

    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView("Cargando posts...")
                } else {
                    ForEach(posts) { post in
                        PostViewComponent(
                            profileImage: Image(systemName: "person.crop.circle"), // Aquí podrías cargar la imagen de perfil si la tienes
                            name: post.nombre,
                            date: post.fechaFormatted,
                            description: post.descripcion,
                            reportImageURL: "http://10.22.233.131:3000\(post.imagen ?? "")" // URL de la imagen del reporte
                        )
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Foro")
            .navigationBarItems(trailing: Button(action: {
                isPresentingNewPostView.toggle() // Mostrar la vista para crear un nuevo post
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            })
            .sheet(isPresented: $isPresentingNewPostView) {
                NewPostView(isPresented: $isPresentingNewPostView) // Llama la vista del nuevo post
            }
            .onAppear {
                fetchPosts() // Llamada para obtener los posts al cargar la vista
            }
        }
    }

    // Función para obtener los posts del API
    func fetchPosts() {
        guard let url = URL(string: "http://10.22.233.131:3000/posts") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al obtener los posts: \(error)")
                return
            }
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        self.posts = decodedPosts
                        self.isLoading = false
                    }
                }
            }
        }.resume()
    }
}

#Preview {
    ForoView()
}
