import SwiftUI
import MusicKit
import SwiftData

struct SongDetailView: View {
    var song: Song
    @Environment(\.modelContext) private var context // Per accedere al contesto SwiftData
    @Query private var ratedSongs: [RatedSong]       // Query per recuperare dati esistenti

    @State private var rating: Int? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Immagine della canzone
                if let artwork = song.artwork {
                    ArtworkImage(artwork, height: 200)
                        .cornerRadius(16)
                        .shadow(radius: 5)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 200, height: 200)
                        .cornerRadius(16)
                        .overlay(Text("No Artwork Available").foregroundColor(.gray))
                }

                // Titolo e informazioni
                Text(song.title)
                    .font(.title2)
                    .bold()

                VStack(spacing: 10) {
                    Text("Artist: \(song.artistName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(song.albumTitle ?? "Unknown Album")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Divider()

                // Rating
                VStack(spacing: 10) {
                    Text("Rate this Song")
                        .font(.headline)

                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: {
                                rating = star
                                saveRating(star)
                            }) {
                                Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                                    .foregroundColor(star <= (rating ?? 0) ? .yellow : .gray)
                                    .font(.title)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Song Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadExistingRating()
        }
    }

    // MARK: - Metodi SwiftData
    private func loadExistingRating() {
        if let existingRating = ratedSongs.first(where: { $0.id == song.id.rawValue }) {
            self.rating = existingRating.rating
        }
    }

    private func saveRating(_ newRating: Int) {
        if let existingSong = ratedSongs.first(where: { $0.id == song.id.rawValue }) {
            // Aggiorna il rating esistente
            existingSong.rating = newRating
        } else {
            // Crea una nuova entry
            let ratedSong = RatedSong(
                id: song.id.rawValue,
                title: song.title,
                artistName: song.artistName,
                albumTitle: song.albumTitle,
                artworkURL: song.artwork?.url(width: 200, height: 200),
                rating: newRating
            )
            context.insert(ratedSong)
        }
    }
}
