import SwiftUI
import MusicKit

struct SearchAlbumView: View {
    var albumItem: Album

    var body: some View {
        HStack(spacing: 16) {
            if let artwork = albumItem.artwork {
                ArtworkImage(artwork, height: 60) // Display the album artwork
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(albumItem.title) // Album title
                    .font(.headline)
                    .lineLimit(1)

                Text(albumItem.artistName) // Artist name
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer() // Push content to the left
        }
        .padding(.vertical, 8)
    }
}
