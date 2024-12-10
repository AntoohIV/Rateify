import SwiftUI

struct HomeView: View {
    @State private var ratedTracks = [(String, Int)]() // Tracks rated by the user
    
    var songList = SongList() // Simulating a list of songs

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Sezione per le canzoni consigliate
                    VStack(alignment: .leading) {
                        Text("Recommended for You")
                            .font(.headline)
                            .padding(.horizontal)
                        VStack(spacing: 15) {
                            ForEach(songList.songs.prefix(5), id: \.id) { song in
                                HStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                    VStack(alignment: .leading) {
                                        Text(song.title)
                                            .font(.body)
                                            .lineLimit(1)
                                        Text(song.artist)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                        Text("Duration: \(Int(song.duration / 60)) min")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        if let releaseDate = song.releaseDate {
                                            Text("Released: \(releaseDate, formatter: dateFormatter)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        // Rating Button
                                        Button(action: {
                                            // Add the song to ratedTracks with a rating of 4 (for example)
                                            ratedTracks.append((song.title, 4))
                                        }) {
                                            Text("Rate this Song")
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()


#Preview {
    HomeView()
}
