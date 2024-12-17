//
//  RateifyApp.swift
//  Rateify
//
//  Created by Antonio Odore on 06/12/24.
//

import SwiftUI
import SwiftData
import MusicKit

@main
struct RateifyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([RatedAlbum.self, RatedSong.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}

