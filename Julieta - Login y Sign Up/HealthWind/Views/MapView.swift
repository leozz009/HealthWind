//
//  MapView.swift
//  HealthWind
//
//  Created by Leonardo González on 09/10/24.
//

import SwiftUI

struct AppError: Identifiable {
    let id = UUID()
    let message: String
}

struct MapView: View {
    @State var search: String = ""
    @State var selection = 1
    @State private var viewModel = MapViewModel(completer: .init())
    @State private var searchResults = [SearchResult]()
    @State private var isPresentingSearchResults: Bool = false
    @State private var error: AppError?
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            // Mapa en el fondo con zIndex bajo
            MapViewComponent(searchResults: $searchResults, viewModel: $viewModel)
                .zIndex(-1)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(EdgeInsets(top: 190, leading: 20, bottom: 50, trailing: 20))
                
            
            
            VStack {
                // Título
                Text("Mapa Interactivo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                // Barra de búsqueda
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading)
                    
                    TextField("Buscar", text: $search)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8))
                        .onSubmit {
                            Task {
                                searchResults = (try? await viewModel.search(with: search)) ?? []
                            }
                        }
                }
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.primary)
                .padding(.horizontal)
                

                Picker("Option", selection: $selection) {
                    Text("Contaminación").tag(0)
                    Text("Áreas Verdes").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
            }
            .onChange(of: search) {
                viewModel.update(queryFragment: search)
            }

            
            if !viewModel.completions.isEmpty {
                List {
                    ForEach(viewModel.completions) { completion in
                        Button(action: {
                            performSingleSearch(completion: completion)
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(completion.title)
                                    .font(.headline)
                                    .fontDesign(.rounded)
                                Text(completion.subTitle)
                            }
                        }
                        .listRowBackground(Color.gray.opacity(0.1))
                    }
                }
                .frame(height: 200)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.95))
                .cornerRadius(8)
                .padding(EdgeInsets(top: -270, leading: 20, bottom: 0, trailing: 20))
                .shadow(radius: 5)
                
            }
        }.sheet(isPresented: $viewModel.singleSelection){
            MapSheetView()
        }
        .alert(item: $error) { appError in
                    Alert(title: Text("Error"), message: Text(appError.message), dismissButton: .default(Text("OK")))
                }
        
    }
    
    private func performSingleSearch(completion: SearchCompletions) {
        Task {
            do {
                let results = try await viewModel.search(with: "\(completion.title) \(completion.subTitle)")
                DispatchQueue.main.async {
                    if let singleLocation = results.first {
                        self.searchResults = [singleLocation]
                        self.viewModel.completions.removeAll()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = AppError(message: error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    MapView(selectedTab: .constant(1))
}
