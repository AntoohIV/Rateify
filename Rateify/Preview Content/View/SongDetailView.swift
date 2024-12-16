import SwiftUI
import MusicKit

struct SongDetailView: View {
    var song: Song
    @State private var rating: Int? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Copertura dell'immagine della canzone
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

                // Titolo della canzone
                Text(song.title)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                // Informazioni aggiuntive (Artista e Album)
                VStack(alignment: .center, spacing: 10) {
                    Text("Artist: \(song.artistName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(song.albumTitle ?? "Unknown Album")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Divider()

                // Rating della canzone
                VStack(spacing: 10) {
                    Text("Rate this Song")
                        .font(.headline)

                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: {
                                rating = star
                            }) {
                                Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                                    .foregroundColor(star <= (rating ?? 0) ? .yellow : .gray)
                                    .font(.title)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }

                Divider()

                // Pulsante per riprodurre la canzone con il lettore musicale di sistema
                VStack(spacing: 10) {
                    Button("Play Song with System Player") {
                        Task {
                            // Queue per la canzone selezionata
                            SystemMusicPlayer.shared.queue = .init(for: [song])
                            do {
                                try await SystemMusicPlayer.shared.play()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Song Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
