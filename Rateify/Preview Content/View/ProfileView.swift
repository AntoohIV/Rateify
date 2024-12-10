//
//  ProfileView.swift
//  Rateify
//
//  Created by Antonio Odore on 10/12/24.
//

import SwiftUI

struct ProfileView: View {
    // Simuliamo un profilo con dati di esempio
    let userName = "John Doe"
    let userImage = "person.circle.fill"
    
    // Simuliamo canzoni con valutazione 1 stella
    let ratedTracks = [
        ("Song 1", 1),
        ("Song 2", 1),
        ("Song 3", 1)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Sezione per le informazioni utente
                HStack {
                    Image(systemName: userImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text(userName)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Music Lover")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.top)
                
                Divider()
                
                // Sezione per gli album/canzoni votate
                VStack(alignment: .leading, spacing: 15) {
                    Text("Rated Songs")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    List(ratedTracks, id: \.0) { song, rating in
                        HStack {
                            Text(song)
                                .font(.body)
                            
                            Spacer()
                            
                            // Rating (1 stella su 5)
                            HStack {
                                ForEach(0..<5) { index in
                                    if index < rating {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                    } else {
                                        Image(systemName: "star")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}


#Preview {
    ProfileView()
}
