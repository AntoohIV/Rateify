import MusicKit
import SwiftUI

struct ArtistDetailView: View {
    var artist: Artist
    @State private var albums: [Album] = []
    @State private var songs: [Song] = []
    @State private var artistArtworkURL: URL? = nil
    @State private var isLoading: Bool = true

    var body: some View {
        VStack {
            if let artworkURL = artistArtworkURL {
                // Artwork dell'artista
                AsyncImage(url: artworkURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    case .failure:
                        Image(systemName: "person.crop.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding()
            }

            // Nome dell'artista
            Text(artist.name)
                .font(.largeTitle)
                .bold()
                .padding(.bottom)

            if isLoading {
                ProgressView("Loading artist data...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                // Sezione Album
                VStack(alignment: .leading) {
                    Text("Albums")
                        .font(.title2)
                        .bold()
                        .padding(.leading)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(albums, id: \.id) { album in
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
                                        .lineLimit(1)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 150)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)

                // Sezione Songs
                VStack(alignment: .leading) {
                    Text("Songs")
                        .font(.title2)
                        .bold()
                        .padding(.leading)

                    List(songs, id: \.id) { song in
                        HStack {
                            AsyncImage(url: song.artwork?.url(width: 50, height: 50)) { phase in
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
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)

                            Text(song.title)
                                .font(.headline)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
        .navigationTitle(artist.name)
        .onAppear {
            fetchArtistData()
        }
        .padding()
    }

    func fetchArtistData() {
        Task {
            isLoading = true
            do {
                let artistRequest = MusicCatalogResourceRequest<Artist>(matching: \.id, equalTo: artist.id)
                let artistResponse = try await artistRequest.response()

                if let foundArtist = artistResponse.items.first {
                    self.artistArtworkURL = foundArtist.artwork?.url(width: 500, height: 500)

                    let albumRequest = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: artist.id)
                    let albumResponse = try await albumRequest.response()

                
                    self.albums = Array(albumResponse.items)

                    // Recupero Canzoni dell'artista
                    let songRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: artist.id)
                    let songResponse = try await songRequest.response()
                    self.songs = Array(songResponse.items)
                }
                isLoading = false
            } catch {
                print("Error fetching artist data: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
}
