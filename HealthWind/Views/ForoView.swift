import SwiftUI


struct ForoView: View {
    @State private var isPresentingNewPostView = false
    @State private var posts: [Post] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView("Cargando posts...")
                } else {
                    ForEach(posts) { post in
                        PostViewComponent(
                            profileImage: Image(systemName: "person.crop.circle"),
                            name: post.nombre,
                            date: post.fechaFormatted,
                            description: post.descripcion,
                            reportImageURL: (post.imagen ?? "").isEmpty ? nil : "http://10.22.233.131:3000\(post.imagen!)"
                        )
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarItems(trailing: Button(action: {
                isPresentingNewPostView.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            })
            .sheet(isPresented: $isPresentingNewPostView) {
                NewPostView(isPresented: $isPresentingNewPostView, refreshPosts: fetchPosts)
            }
            .onAppear {
                fetchPosts()
            }
        }
    }

    func fetchPosts() {
        guard let url = URL(string: "http://10.22.233.131:3000/posts") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al obtener los posts: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        self.posts = decodedPosts
                        self.isLoading = false
                    }
                } else {
                    print("Error al decodificar los posts")
                    DispatchQueue.main.async {
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
