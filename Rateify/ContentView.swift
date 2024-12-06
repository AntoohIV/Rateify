import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            ProfileView()  // Cambiato il nome della vista a ProfileView
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

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

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Section 1
                    VStack(alignment: .leading) {
                        Text("Recently Played")
                            .font(.headline)
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<10) { _ in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 150, height: 150)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Section 2
                    VStack(alignment: .leading) {
                        Text("Recommended for You")
                            .font(.headline)
                            .padding(.horizontal)
                        VStack(spacing: 15) {
                            ForEach(0..<5) { _ in
                                HStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                    Text("Song/Playlist Name")
                                        .font(.body)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
        }
    }
}

struct ExploreView: View {
    let categories = [
        ("Pop", Color.pink),
        ("Hip-Hop", Color.blue),
        ("Jazz", Color.orange),
        ("Rock", Color.red),
        ("Classical", Color.green),
        ("Electronic", Color.purple),
        ("Indie", Color.yellow),
        ("R&B", Color.teal)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Search...", text: .constant(""))
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .overlay(
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 20)
                            }
                        )
                }
                .padding(.top)
                
                // Explore Categories
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Explore Categories")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(categories, id: \.0) { category, color in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(color.opacity(0.7))
                                        .frame(height: 120)
                                    Text(category)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Suggested Playlists
                        Text("Suggested Playlists")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            ForEach(0..<5) { _ in
                                HStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                    VStack(alignment: .leading) {
                                        Text("Playlist Name")
                                            .font(.body)
                                        Text("Curated for you")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Explore")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
