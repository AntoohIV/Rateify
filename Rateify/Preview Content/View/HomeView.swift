import SwiftUI
import MusicKit

struct HomeView: View {
    @State private var songs: [Song] = []
    @State private var albums: [Album] = []
    @State private var artists: [Artist] = []
    @State private var isLoading: Bool = false

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
                            Text("Songs")
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
                            Text("Albums")
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
                            Text("Artists")
                                .font(.title2)
                                .bold()
                                .padding(.leading)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(artists, id: \.id) { artist in
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
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        /*Text("Home")
                            .font(.title2)
                            .bold()
                            */
                        Button(action: {
                            fetchRandomSongs()
                            fetchRandomAlbums()
                            fetchRandomArtists()
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
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
                    print("No song charts found.")
                    self.songs = []
                }
            } catch {
                print("Error fetching songs: \(error.localizedDescription)")
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
                    print("No album charts found.")
                    self.albums = []
                }
            } catch {
                print("Error fetching albums: \(error.localizedDescription)")
                self.albums = []
            }
            isLoading = false
        }
    }

    func fetchRandomArtists() {
        Task {
            isLoading = true
            do {
                let request = MusicCatalogSearchRequest(term: "a", types: [Artist.self])
                let response = try await request.response()

                let allArtists = response.artists.compactMap { $0 }
                self.artists = Array(allArtists.shuffled().prefix(10))
            } catch {
                print("Error fetching artists: \(error.localizedDescription)")
                self.artists = []
            }
            isLoading = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
