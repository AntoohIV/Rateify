import SwiftUI
import MusicKit
import SwiftData

struct AlbumDetailsView: View {
    @Environment(\.modelContext) private var modelContext // Contesto SwiftData
    @State private var updatedAlbumObject: Album?
    @State private var rating: Int? = nil // Stato per la valutazione dell'album
    
    var album: Album
    
    private let artworkHeight: CGFloat = 200 // Altezza costante per l'artwork
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Copertina dell'album
                albumArtwork
                
                // Informazioni principali sull'album
                albumInfo
                
                Divider()
                
                // Valutazione dell'album (stelle)
                ratingSection
                
                Divider()
                
                // Tracklist dell'album
                tracklistSection
                
                Divider()
                
                // Pulsante per riprodurre l'album
                playButton
            }
            .padding()
        }
        .navigationTitle("Album Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadAlbumTracks()
            loadExistingRating() // Carica la valutazione esistente
        }
    }
    
    // MARK: - Sezioni della UI
    
    private var albumArtwork: some View {
        Group {
            if let artwork = album.artwork {
                ArtworkImage(artwork, height: artworkHeight)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: artworkHeight, height: artworkHeight)
                    .cornerRadius(10)
                    .overlay(Text("No Artwork Available").foregroundColor(.gray))
            }
        }
    }
    
    private var albumInfo: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(album.title)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("Artist: \(album.artistName)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            if let releaseDate = album.releaseDate {
                Text("Release Date: \(releaseDate, format: .dateTime.year().month().day())")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    private var ratingSection: some View {
        VStack(spacing: 10) {
            Text("Rate this Album")
                .font(.headline)
            
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        withAnimation {
                            rating = star
                            saveRating() // Salva la valutazione
                        }
                    }) {
                        Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                            .foregroundColor(star <= (rating ?? 0) ? .yellow : .gray)
                            .font(.title)
                    }
                }
            }
        }
    }
    
    private var tracklistSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tracklist")
                .font(.headline)
            
            if let tracks = updatedAlbumObject?.tracks {
                ForEach(Array(tracks.enumerated()), id: \.element.id) { index, track in
                    switch track {
                    case .song(let songItem):
                        HStack {
                            Text("\(index + 1).")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(songItem.title)
                                .font(.body)
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    case .musicVideo(_):
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                ProgressView("Loading tracks...")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    private var playButton: some View {
        VStack(spacing: 10) {
            Button("Play Album with System Player") {
                Task {
                    SystemMusicPlayer.shared.queue = .init(for: [album])
                    do {
                        try await SystemMusicPlayer.shared.play()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.top)
    }
    
    // MARK: - Funzione per salvare la valutazione
    
    private func saveRating() {
        guard let rating = rating else { return }
        
        // Estrai l'URL dell'artwork
        let artworkURL = album.artwork?.url
        
        // Controlla se esiste già una valutazione per questo album
        do {
            let existingRating = try modelContext.fetch(FetchDescriptor<RatedAlbum>(
                predicate: #Predicate { $0.id == album.id.rawValue }
            ))
            
            if let existing = existingRating.first {
                existing.rating = rating
            } else {
                // Crea una nuova valutazione
                let newRatedAlbum = RatedAlbum(
                    id: album.id.rawValue,
                    title: album.title,
                    artistName: album.artistName,
                    rating: rating,
                    artworkURL: album.artwork?.url(width: 200, height: 200)
                )
                modelContext.insert(newRatedAlbum)
            }
            
            try modelContext.save()
            print("Rating saved successfully")
        } catch {
            print("Failed to save rating: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Funzione per caricare le tracce dell'album
    
    private func loadAlbumTracks() async {
        do {
            self.updatedAlbumObject = try await album.with([.tracks])
        } catch {
            print("Failed to load tracks: \(error.localizedDescription)")
        }
    }
    
    // Funzione per caricare la valutazione esistente
    private func loadExistingRating() {
        if let existingRating = try? modelContext.fetch(FetchDescriptor<RatedAlbum>(
            predicate: #Predicate { $0.id == album.id.rawValue }
        )).first {
            self.rating = existingRating.rating
        }
    }
}
