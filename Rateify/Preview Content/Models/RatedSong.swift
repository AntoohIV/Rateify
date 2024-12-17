//
//  RatedSong.swift
//  Rateify
//
//  Created by Antonio Odore on 17/12/24.
//


import Foundation
import SwiftData

@Model
class RatedSong {
    @Attribute(.unique) var id: String // Identificatore unico della canzone
    var title: String
    var artistName: String
    var albumTitle: String?
    var artworkURL: URL?
    var rating: Int
    
    init(id: String, title: String, artistName: String, albumTitle: String?, artworkURL: URL?, rating: Int = 0) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.albumTitle = albumTitle
        self.artworkURL = artworkURL
        self.rating = rating
    }
}
