//
//  ExploreView.swift
//  Rateify
//
//  Created by Antonio Odore on 11/12/24.
//


import SwiftUI
import MusicKit

struct ExploreView: View {
    @State private var searchTerm: String = ""
    @State private var searchResultSongs: MusicItemCollection<Song> = []
    @State private var isPerformingSearch: Bool = false

    @State private var musicSubscription: MusicSubscription?
    private var resultLimit: Int = 15

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                TextField("Search for songs", text: $searchTerm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if isPerformingSearch {
                    ProgressView()
                        .padding(.trailing)
                } else {
                    Button(action: performSearch) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                    .disabled(searchTerm.isEmpty || !(musicSubscription?.canPlayCatalogContent ?? false))
                }
            }

            if !searchResultSongs.isEmpty {
                List(searchResultSongs, id: \.id) { song in
                    SongInfoView(songItem: song)
                }
            } else if !isPerformingSearch && !searchTerm.isEmpty {
                Text("No results found.")
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
        }
        .task {
            for await subscription in MusicSubscription.subscriptionUpdates {
                self.musicSubscription = subscription
            }
        }
    }

    private func performSearch() {
        Task {
            do {
                let request = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                self.isPerformingSearch = true
                let response = try await request.response()
                self.isPerformingSearch = false
                self.searchResultSongs = response.songs
            } catch {
                print(error.localizedDescription)
                self.isPerformingSearch = false
            }
        }
    }
}

#Preview {
    ExploreView()
}
