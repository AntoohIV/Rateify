import SwiftUI
import MusicKit

struct HomeView: View {
    @State private var songs: [Song] = []
    @State private var albums: [Album] = []
    @State private var artists: [Artist] = []
    @State private var isLoading: Bool = false
    
    // Stato per il selettore di genere
    @State private var selectedGenre: String = "random"
    let genres: [String] = ["random", "pop", "rock", "hip-hop", "jazz", "classical"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if isLoading {
                        ProgressView("Loading new music...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        // Section for Songs
                        VStack(alignment: .leading) {
                            Text("Top Songs")
                                .font(.title2)
                                .bold()
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(songs, id: \.id) { song in
                                        NavigationLink {
                                            SongDetailView(song: song)
                                        } label: {
                                            VStack {
                                                AsyncImage(url: song.artwork?.url(width: 150, height: 150)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image.resizable().scaledToFit()
                                                    case .failure:
                                                        Image(systemName: "music.note")
                                                            .resizable()
                                                            .scaledToFit()
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(8)
                                                
                                                Text(song.title)
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                    .multilineTextAlignment(.center)
                                                
                                                Text(song.artistName)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 150)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Section for Albums
                        VStack(alignment: .leading) {
                            Text("Top Albums")
                                .font(.title2)
                                .bold()
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(albums, id: \.id) { album in
                                        NavigationLink {
                                            AlbumDetailsView(album: album)
                                        } label: {
                                            VStack {
                                                AsyncImage(url: album.artwork?.url(width: 150, height: 150)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image.resizable().scaledToFit()
                                                    case .failure:
                                                        Image(systemName: "photo")
                                                            .resizable()
                                                            .scaledToFit()
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(8)
                                                
                                                Text(album.title)
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                    .multilineTextAlignment(.center)
                                                
                                                Text(album.artistName)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 150)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Section for Artists
                        VStack(alignment: .leading) {
                            // Titolo con Picker
                            HStack {
                                Text("Artists")
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                                
                                Picker("Genre", selection: $selectedGenre) {
                                    ForEach(genres, id: \.self) { genre in
                                        Text(genre.capitalized).tag(genre)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle()) // Menu compatto
                            }
                            .padding(.horizontal)
                            
                            // Lista Artisti
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(artists, id: \.id) { artist in
                                        NavigationLink(destination: ArtistDetailView(artist: artist)) {
                                            VStack {
                                                AsyncImage(url: artist.artwork?.url(width: 150, height: 150)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image.resizable().scaledToFit()
                                                    case .failure:
                                                        Image(systemName: "person")
                                                            .resizable()
                                                            .scaledToFit()
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(8)
                                                
                                                Text(artist.name)
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                    .multilineTextAlignment(.center)
                                            }
                                            .frame(width: 150)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .onChange(of: selectedGenre) { _ in
                            fetchRandomArtists()
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        fetchRandomSongs()
                        fetchRandomAlbums()
                        fetchRandomArtists()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                fetchRandomSongs()
                fetchRandomAlbums()
                fetchRandomArtists()
            }
        }
    }
    
    func fetchRandomSongs() {
        Task {
            isLoading = true
            do {
                let request = MusicCatalogChartsRequest(types: [Song.self])
                let response = try await request.response()
                
                if let songCharts = response.songCharts.first(where: { $0.items.contains(where: { $0 is Song }) }) {
                    let allSongs = songCharts.items.compactMap { $0 as? Song }
                    self.songs = Array(allSongs.shuffled().prefix(10))
                } else {
                    self.songs = []
                }
            } catch {
                self.songs = []
            }
            isLoading = false
        }
    }
    
    func fetchRandomAlbums() {
        Task {
            isLoading = true
            do {
                let request = MusicCatalogChartsRequest(types: [Album.self])
                let response = try await request.response()
                
                if let albumCharts = response.albumCharts.first(where: { $0.items.contains(where: { $0 is Album }) }) {
                    let allAlbums = albumCharts.items.compactMap { $0 as? Album }
                    self.albums = Array(allAlbums.shuffled().prefix(10))
                } else {
                    self.albums = []
                }
            } catch {
                self.albums = []
            }
            isLoading = false
        }
    }
    
    func fetchRandomArtists() {
        Task {
            isLoading = true
            let randomGenres = ["pop", "rock", "hip-hop", "jazz", "classical", "indie", "electronic"]
            let randomGenre = randomGenres.randomElement() ?? "pop"
            
            do {
                let request = MusicCatalogSearchRequest(term: randomGenre, types: [Artist.self])
                let response = try await request.response()
                
                let allArtists = response.artists.compactMap { $0 }
                self.artists = Array(allArtists.shuffled().prefix(10))
            } catch {
                self.artists = []
                print("Error fetching artists: \(error)")
            }
            isLoading = false
        }
    }
    
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
}
