import SwiftUI
import MusicKit

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel() // Use ViewModel to handle state
    @State private var searchTerm: String = ""
    @State private var searchResultSongs: MusicItemCollection<Song> = []
    @State private var searchResultAlbums: MusicItemCollection<Album> = [] // New state for albums
    @State private var isPerformingSearch: Bool = false
    @State private var musicSubscription: MusicSubscription?
    private var resultLimit: Int = 15
    @State private var selectedSearchType: SearchType = .song // Default to song
    
    enum SearchType: String, CaseIterable, Identifiable {
        case song = "Song"
        case album = "Album"
        
        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("Search Type", selection: $selectedSearchType) {
                    ForEach(SearchType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    if selectedSearchType == .song {
                        ForEach(searchResultSongs.prefix(resultLimit), id: \.id) { song in
                            NavigationLink(destination: SongDetailView(song: song)) {
                                SongInfoView(songItem: song)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowSeparator(.hidden, edges: .all)
                        }
                    } else {
                        ForEach(searchResultAlbums.prefix(resultLimit), id: \.id) { album in
                            NavigationLink(destination: AlbumDetailsView(album: album)) {
                                SearchAlbumView(albumItem: album)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Explore")
                .searchable(text: $viewModel.searchText, prompt: selectedSearchType == .song ? "Search for songs..." : "Search for albums...")
                .onChange(of: viewModel.searchText) { old, newSearchTerm in
                    performSearch()
                }

                if isPerformingSearch {
                    ProgressView()
                        .padding(.trailing)
                } else {
                    if selectedSearchType == .song {
                        if !searchResultSongs.isEmpty {
                            Text("Results found: \(searchResultSongs.count)")
                                .foregroundColor(.gray)
                                .padding()
                        } else if !isPerformingSearch && !searchTerm.isEmpty {
                            Text("No results found.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    } else {
                        if !searchResultAlbums.isEmpty {
                            Text("Results found: \(searchResultAlbums.count)")
                                .foregroundColor(.gray)
                                .padding()
                        } else if !isPerformingSearch && !searchTerm.isEmpty {
                            Text("No results found.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }

                    if !(musicSubscription?.canPlayCatalogContent ?? false) {
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
                if selectedSearchType == .song {
                    let request = MusicCatalogSearchRequest(term: viewModel.searchText, types: [Song.self])
                    self.isPerformingSearch = true
                    let response = try await request.response()
                    self.isPerformingSearch = false
                    self.searchResultSongs = response.songs
                } else {
                    let request = MusicCatalogSearchRequest(term: viewModel.searchText, types: [Album.self])
                    self.isPerformingSearch = true
                    let response = try await request.response()
                    self.isPerformingSearch = false
                    self.searchResultAlbums = response.albums
                }
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
