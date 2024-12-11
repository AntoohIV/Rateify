//
//  Song.swift
//  Rateify
//
//  Created by Antonio Odore on 11/12/24.
//
import Foundation
import SwiftData



@Model
class Song {
    var id: UUID = UUID()
    var title: String       // Titolo della canzone
    var artist: String      // Artista
    var duration: TimeInterval                    // Durata in secondi
    var releaseDate: Date?                        // Data di uscita
    var genre: String?                            // Genere musicale
    var coverImageURL: String?                    // URL o percorso dell'immagine della copertina
    var rating: Int?                               // Voto da 1 a 5 stelle (opzionale)

    init(
        title: String,
        artist: String,
        duration: TimeInterval,
        releaseDate: Date? = nil,
        genre: String? = nil,
        coverImageURL: String? = nil,
        rating: Int? = nil  // Aggiunta della proprietà rating
    ) {
        self.title = title
        self.artist = artist
        self.duration = duration
        self.releaseDate = releaseDate
        self.genre = genre
        self.coverImageURL = coverImageURL
        self.rating = rating
    }
}

struct SongList {
    var songs: [Song]

    // Costruttore che si occupa dell'inizializzazione delle canzoni
    init() {
        songs = [
            Song(
                title: "Blinding Lights",
                artist: "The Weeknd",
                duration: 200,
                releaseDate: SongList.dateFormatter(date: "2019-11-29"),
                genre: "Pop",
                coverImageURL: "https://example.com/cover/blinding_lights.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Shape of You",
                artist: "Ed Sheeran",
                duration: 233,
                releaseDate: SongList.dateFormatter(date: "2017-01-06"),
                genre: "Pop",
                coverImageURL: "https://example.com/cover/shape_of_you.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Bad Guy",
                artist: "Billie Eilish",
                duration: 194,
                releaseDate: SongList.dateFormatter(date: "2019-03-29"),
                genre: "Pop",
                coverImageURL: "https://example.com/cover/bad_guy.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Uptown Funk",
                artist: "Mark Ronson ft. Bruno Mars",
                duration: 269,
                releaseDate: SongList.dateFormatter(date: "2014-11-10"),
                genre: "Funk",
                coverImageURL: "https://example.com/cover/uptown_funk.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Rolling in the Deep",
                artist: "Adele",
                duration: 228,
                releaseDate: SongList.dateFormatter(date: "2010-11-29"),
                genre: "Soul",
                coverImageURL: "https://example.com/cover/rolling_in_the_deep.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Thank U, Next",
                artist: "Ariana Grande",
                duration: 221,
                releaseDate: SongList.dateFormatter(date: "2019-11-03"),
                genre: "Pop",
                coverImageURL: "https://example.com/cover/thank_u_next.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Old Town Road",
                artist: "Lil Nas X",
                duration: 157,
                releaseDate: SongList.dateFormatter(date: "2019-12-03"),
                genre: "Country Rap",
                coverImageURL: "https://example.com/cover/old_town_road.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Party in the U.S.A.",
                artist: "Miley Cyrus",
                duration: 200,
                releaseDate: SongList.dateFormatter(date: "2009-04-06"),
                genre: "Pop",
                coverImageURL: "https://example.com/cover/party_in_the_usa.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Stay",
                artist: "The Kid LAROI & Justin Bieber",
                duration: 137,
                releaseDate: SongList.dateFormatter(date: "2021-07-09"),
                genre: "Pop",
                coverImageURL: "https://example.com/cover/stay.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            ),
            Song(
                title: "Happier",
                artist: "Marshmello ft. Bastille",
                duration: 200,
                releaseDate: SongList.dateFormatter(date: "2018-08-17"),
                genre: "Pop",
                coverImageURL: "https://example.com/cover/happier.jpg",
                rating: 5 // Aggiungi una valutazione da 1 a 5 stelle
            )
        ]
    }
    
    // Funzione per creare una data da una stringa
    static func dateFormatter(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
}



