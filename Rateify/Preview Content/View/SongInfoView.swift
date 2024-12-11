import SwiftUI
import MusicKit

struct SongInfoView: View {
    var songItem: Song

    var body: some View {
        HStack(spacing: 16) {
            if let artwork = songItem.artwork {
                ArtworkImage(artwork, height: 60) // Display the artwork
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(songItem.title) // Song title
                    .font(.headline)
                    .lineLimit(1)

                Text(songItem.artistName) // Artist name
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer() // Push content to the left
        }
        .padding(.vertical, 8)
    }
}
