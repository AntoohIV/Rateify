//
//  AlbumDetailsView.swift
//  Rateify
//
//  Created by Antonio Odore on 14/12/24.
//
import SwiftUI
import MusicKit

struct AlbumDetailsView: View {
    @State private var updatedAlbumObject: Album?
    @State private var rating: Int? = nil
    var album: Album

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Copertina dell'album
                if let artwork = album.artwork {
                    ArtworkImage(artwork, height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                        .overlay(Text("No Artwork Available").foregroundColor(.gray))
                }

                // Informazioni principali centrato
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
                .padding(.horizontal)

                Divider()

                // Valutazione da 1 a 5 stelle
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
                }
                .padding(.horizontal)

                Divider()

                // Tracklist
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tracklist")
                        .font(.headline)

                    if let tracks = self.updatedAlbumObject?.tracks {
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
                                    Spacer() // This ensures the text is aligned to the left
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
                .padding(.horizontal)

                Divider()

                // Pulsante per riprodurre l'album
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
            .padding()
        }
        .navigationTitle("Album Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            self.updatedAlbumObject = try? await album.with([.tracks])
        }
    }
}
