import SwiftUI
import MusicKit

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel() // Use ViewModel to handle state
    @State private var searchTerm: String = ""
    @State private var searchResultSongs: MusicItemCollection<Song> = []
    @State private var isPerformingSearch: Bool = false
    @State private var musicSubscription: MusicSubscription?
    private var resultLimit: Int = 15

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                List {
                    ForEach(searchResultSongs.prefix(resultLimit), id: \.id) { song in
                        // Wrap each song in a NavigationLink to navigate to a details screen
                        NavigationLink(destination: SongDetailView(song: song)) {
                            SongInfoView(songItem: song)
                        }
                        .buttonStyle(PlainButtonStyle()) // Optional: to avoid the default button style
                        .listRowSeparator(.hidden, edges: .all)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Search for Songs")
                .searchable(text: $viewModel.searchText, prompt: "Search for songs...")
                .onChange(of: viewModel.searchText) { old, newSearchTerm in
                    performSearch()
                }

                if isPerformingSearch {
                    ProgressView()
                        .padding(.trailing)
                } else {
                    if !searchResultSongs.isEmpty {
                        Text("Results found: \(searchResultSongs.count)")
                            .foregroundColor(.gray)
                            .padding()
                    } else if !isPerformingSearch && !searchTerm.isEmpty {
                        Text("No results found.")
                            .foregroundColor(.gray)
                            .padding()
                    } else if !(musicSubscription?.canPlayCatalogContent ?? false) {
                        Text("You need an active subscription to view content.")
                            .foregroundColor(.red)
                            .padding()
                    }
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
                let request = MusicCatalogSearchRequest(term: viewModel.searchText, types: [Song.self])
                self.isPerformingSearch = true
                let response = try await request.response()
                self.isPerformingSearch = false
                self.searchResultSongs = response.songs
            } catch {
                print(error.localizedDescription)
                self.isPerformingSearch = false
            }
        }
    }
}

class ExploreViewModel: ObservableObject {
    @Published var searchText: String = ""
}


#Preview {
    ExploreView()
}
