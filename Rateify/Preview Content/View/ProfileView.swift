//
//  ProfileView.swift
//  Rateify
//
//  Created by Antonio Odore on 11/12/24.
//

import SwiftUI
import MusicKit
import SwiftData

struct ProfileView: View {
    // Dati di esempio (questi dovrebbero essere collegati al tuo modello di dati o database)
    @State private var userName = "Nome Utente" // Variabile di stato per il nome dell'utente
    let userImage = "profile_image" // Il nome dell'immagine dell'utente
    
    // Esempio di canzoni e album votati
    let ratedSongs = ["Song 1", "Song 2", "Song 3"]
    let ratedAlbums = ["Album 1", "Album 2", "Album 3"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Immagine e nome dell'utente
                VStack {
                    Image(userImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                    
                    // Campo di testo per il nome dell'utente
                    TextField("Nome Utente", text: $userName)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                // Lista delle canzoni votate
                VStack(alignment: .leading) {
                    Text("Canzoni Votate")
                        .font(.headline)
                        .padding(.leading)
                    
                    List(ratedSongs, id: \.self) { song in
                        Text(song)
                    }
                }
                
                // Lista degli album votati
                VStack(alignment: .leading) {
                    Text("Album Votati")
                        .font(.headline)
                        .padding(.leading)
                    
                    List(ratedAlbums, id: \.self) { album in
                        Text(album)
                    }
                }
            }
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
