//
//  RatedAlbum.swift
//  Rateify
//
//  Created by Antonio Odore on 17/12/24.
//


import Foundation
import SwiftData

@Model
class RatedAlbum {
    @Attribute(.unique) var id: String
    var title: String
    var artistName: String
    var rating: Int
    var artworkURL: URL?  // Aggiungi questa proprietà

    init(id: String, title: String, artistName: String, rating: Int = 0, artworkURL: URL?) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.rating = rating
        self.artworkURL = artworkURL
    }
}



