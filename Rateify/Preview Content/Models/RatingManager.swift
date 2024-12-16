//
//  RatingManager.swift
//  Rateify
//
//  Created by Antonio Odore on 16/12/24.
//
import Foundation
import SwiftData
import MusicKit

class RatingManager {
    // Una struttura per mantenere le valutazioni
    struct Rating {
        var id: String
        var score: Int // Punteggio da 1 a 5
    }
    
    // Array per memorizzare le valutazioni
    private var ratings: [Rating] = []
    
    // Funzione per aggiungere o aggiornare la valutazione
    func rate(item: MusicItem, score: Int) {
        // Controlliamo se la valutazione è valida (tra 1 e 5 stelle)
        guard score >= 1 && score <= 5 else {
            print("Errore: La valutazione deve essere tra 1 e 5 stelle.")
            return
        }
        
        // Cerca se l'elemento è già presente nelle valutazioni
        if let index = ratings.firstIndex(where: { $0.id == item.id.rawValue }) {
            // Se presente, aggiorna la valutazione
            ratings[index].score = score
        } else {
            // Altrimenti, aggiungi una nuova valutazione
            let newRating = Rating(id: item.id.rawValue, score: score)
            ratings.append(newRating)
        }
    }
    
    // Funzione per ottenere la valutazione di un elemento
    func getRating(for item: MusicItem) -> Int? {
        return ratings.first(where: { $0.id == item.id.rawValue })?.score
    }
    
    // Funzione per visualizzare tutte le valutazioni
    func listAllRatings() {
        for rating in ratings {
            print("ID: \(rating.id), Punteggio: \(rating.score) stelle")
        }
    }
}
