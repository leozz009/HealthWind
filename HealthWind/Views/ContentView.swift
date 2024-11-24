import SwiftUI

struct ContentView: View {
    @StateObject var navigationModel = NavigationModel()
    @StateObject var authViewModel = AuthViewModel()  // Manejo del estado global de autenticación
    @State var HealthViewModel: HealthViewModel = .init()
    @State var locationViewModel: LocationViewModel = .init()

    var body: some View {
        TabView(selection: $navigationModel.selectedTab) {
            MenuView()
                .padding(.top, 50)
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
                .tag(0)

            MapView(locationViewModel: $locationViewModel)
                .environmentObject(navigationModel)
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
                        .navigationTitle("Sobre tu salud")
                }
                .tabItem {
                    Image(systemName: "heart")
                    Text("Salud")
                }
                .tag(3)

                NavigationView {
                    ProfileView()
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
                .tag(4)
            } else {
                // Si no está autenticado, redirigir al login para Salud y Perfil
                LoginView(selectedTab: $navigationModel.selectedTab)  // Pasamos el Binding
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Salud")
                    }
                    .tag(3)
                
                LoginView(selectedTab: $navigationModel.selectedTab)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Perfil")
                    }
                    .tag(4)
            }
        }
        .environmentObject(authViewModel)
        .onAppear {
            locationViewModel.requestLocation()
        }
        .environmentObject(authViewModel)  // Inyecta el AuthViewModel en todas las vistas
        .environmentObject(navigationModel)
    }
}

#Preview {
    ContentView()
}
