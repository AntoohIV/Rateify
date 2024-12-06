import SwiftUI

struct AlbumDetailView: View {
    let albumTitle: String
    let albumImage: String
    let artistName: String
    let releaseDate: String
    let trackCount: Int
    let tracks: [String]
    
    var body: some View {
        ScrollView {
            VStack {
                // Immagine di sfondo sfocata
                ZStack {
                    Image(systemName: albumImage) // Sostituisci con l'immagine dell'album se disponibile
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 350)
                        .clipped()
                        .blur(radius: 15)
                        .overlay(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .bottom, endPoint: .top))
                    
                    // Cover album in primo piano
                    Image(systemName: albumImage) // Sostituisci con l'immagine dell'album
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.top, 40)
                }
                
                // Dettagli dell'album
                VStack(alignment: .leading, spacing: 10) {
                    Text(albumTitle)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Artist: \(artistName)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Release Date: \(releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("\(trackCount) Tracks")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Pulsante RATE ALBUM e Opzioni
                HStack {
                    Button(action: {
                        // Aggiungi l'azione per rate l'album
                    }) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("RATE ALBUM")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Aggiungi l'azione per le opzioni
                    }) {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                // Tracklist
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tracklist")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(tracks, id: \.self) { track in
                        Text(track)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .navigationTitle("Album Details")
    }
}

struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView(
            albumTitle: "Album Title",
            albumImage: "music.note", // Sostituisci con l'immagine dell'album
            artistName: "Artist Name",
            releaseDate: "January 1, 2023",
            trackCount: 12,
            tracks: ["Track 1", "Track 2", "Track 3", "Track 4", "Track 5", "Track 6", "Track 7", "Track 8", "Track 9", "Track 10", "Track 11", "Track 12"]
        )
    }
}
