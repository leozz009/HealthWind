import SwiftUI

struct ContentView: View {
    @State var selectedTab: Int = 0
    @StateObject var authViewModel = AuthViewModel()  // Manejo del estado global de autenticación
    @State var HealthViewModel: HealthViewModel = .init()

    var body: some View {
        TabView(selection: $selectedTab) {
            MenuView()
                .padding(.top, 50)
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
                .tag(0)

            MapView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "map")
                    Text("Mapa")
                }
                .tag(1)

            NavigationView {
                ReportView()
                    .navigationTitle("Reporte & Foro")
            }
            .tabItem {
                Image(systemName: "camera")
                Text("Reporte")
            }
            .tag(2)

            if authViewModel.isAuthenticated || authViewModel.hasLoggedInBefore {
                // Vistas protegidas
                NavigationView {
                    HealthView(viewModel: $HealthViewModel)
                        .navigationTitle("Mi salud")
                }
                .tabItem {
                    Image(systemName: "heart")
                    Text("Salud")
                }
                .tag(3)

                NavigationView {
                    ProfileView()
                        .navigationTitle("Perfil")
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
                .tag(4)
            } else {
                // Si no está autenticado, redirigir al login para Salud y Perfil
                LoginView(selectedTab: $selectedTab)  // Pasamos el Binding
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Salud")
                    }
                    .tag(3)
                
                LoginView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Perfil")
                    }
                    .tag(4)
            }
        }
        .environmentObject(authViewModel)  // Inyecta el AuthViewModel en todas las vistas
    }
}

#Preview {
    ContentView()
}
