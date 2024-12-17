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
    @Attribute(.unique) var id: String // Identificatore unico per l'album
    var title: String
    var artistName: String
    var rating: Int
    var dateRated: Date

    init(id: String, title: String, artistName: String, rating: Int, dateRated: Date) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.rating = rating
        self.dateRated = dateRated
    }
}



