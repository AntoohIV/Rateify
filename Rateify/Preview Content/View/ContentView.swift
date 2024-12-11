import SwiftUI
import MusicKit

struct ContentView: View {
    
    @AppStorage("isWelcomeViewShowing") var isWelcomeViewShowing: Bool = true
    
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
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .welcomeSheet() // Usa il modificatore per mostrare la WelcomeView come sheet
    }
}

#Preview {
    ContentView()
}
