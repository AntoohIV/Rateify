import SwiftUI

struct ProfileView: View {
    @State private var ratedTracks = [(String, Int)]() // Tracks rated by the user
    
    // Simuliamo un profilo con dati di esempio
    let userName = "John Doe"
    let userImage = "person.circle.fill"
    
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
            .onAppear {
                // Load rated songs (simulate loading for demo)
                loadRatedSongs()
            }
        }
    }
    
    // Simula il caricamento di canzoni votate
    func loadRatedSongs() {
        // For demo purposes, we add a few songs with ratings
        ratedTracks.append(("Song 1", 3))
        ratedTracks.append(("Song 2", 5))
        ratedTracks.append(("Song 3", 4))
    }
}

#Preview {
    ProfileView()
}
