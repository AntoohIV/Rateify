    import SwiftUI
    import MusicKit

    struct SongDetailView: View {
        var song: Song
        @State private var rating: Int? = nil
        @State private var showMenu = false

        var body: some View {
            VStack(spacing: 16) {
                if let artwork = song.artwork {
                    ArtworkImage(artwork, height: 200)
                        .cornerRadius(16)
                }
                
                Text(song.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center) // Per allineare al centro
                    .lineLimit(nil) // Permette il testo su più righe
                    .frame(maxWidth: .infinity) // Assicura che si adatti al contenitore

                Text("Artist: \(song.artistName)")
                    .font(.title2)
                    .foregroundColor(.gray)

                Text(song.albumTitle ?? "Unknown Album")
                    .font(.title3)
                    .foregroundColor(.gray)

                // Rating Buttons
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { star in
                        Button(action: {
                            rating = star
                        }) {
                            Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                                .foregroundColor(star <= (rating ?? 0) ? .yellow : .gray)
                                .font(.title)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .padding(.top)

                // Options Menu
                HStack(spacing: 16) {
                    Button(action: {
                        // Rate button action
                    }) {
                        HStack {
                            Image(systemName: "star")
                            Text("Rate Album")
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke())
                    }
                    
                    Menu {
                        Button(action: {
                            // Play song action
                        }) {
                            Label("Play Song", systemImage: "play.circle")
                        }

                        Button(action: {
                            // Add to listen later action
                        }) {
                            Label("Listen Later", systemImage: "clock")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke())
                    }
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .navigationTitle("Song Details")
        }
    }
