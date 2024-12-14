import SwiftUI
import MusicKit

struct SearchAlbumView: View {
    @StateObject var viewModel = SearchAlbumViewModel() // ViewModel per gestire lo stato della ricerca
    @State private var searchResultAlbums: MusicItemCollection<Album> = []
    @State private var isPerformingSearch: Bool = false
    @State private var musicSubscription: MusicSubscription?
    private var resultLimit: Int = 10

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                List {
                    ForEach(searchResultAlbums.prefix(resultLimit), id: \.id) { album in
                        NavigationLink(destination: AlbumDetailsView(album: album)) {
                            HStack {
                                if let artwork = album.artwork {
                                    ArtworkImage(artwork, height: 60)
                                    .cornerRadius(8)
                                }
                                VStack(alignment: .leading) {
                                    Text(album.title)
                                        .font(.headline)
                                    Text(album.artistName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden, edges: .all)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Search for Albums")
                .searchable(text: $viewModel.searchText, prompt: "Search for albums...")
                .onChange(of: viewModel.searchText) { old, newSearchTerm in
                    performSearch()
                }

                if isPerformingSearch {
                    ProgressView()
                        .padding(.trailing)
                } else if !searchResultAlbums.isEmpty {
                    Text("Results found: \(searchResultAlbums.count)")
                        .foregroundColor(.gray)
                        .padding()
                } else if !isPerformingSearch && !viewModel.searchText.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.gray)
                        .padding()
                } else if !(musicSubscription?.canPlayCatalogContent ?? false) {
                    Text("You need an active subscription to view content.")
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .task {
                for await subscription in MusicSubscription.subscriptionUpdates {
                    self.musicSubscription = subscription
                }
            }
        }
    }

    private func performSearch() {
        Task {
            do {
                let request = MusicCatalogSearchRequest(term: viewModel.searchText, types: [Album.self])
                self.isPerformingSearch = true
                let response = try await request.response()
                self.isPerformingSearch = false
                self.searchResultAlbums = response.albums
            } catch {
                print(error.localizedDescription)
                self.isPerformingSearch = false
            }
        }
    }
}

class SearchAlbumViewModel: ObservableObject {
    @Published var searchText: String = ""
}
