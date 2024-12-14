//
//  HomeView.swift
//  Rateify
//
//  Created by Antonio Odore on 11/12/24.
//

import SwiftUI
import MusicKit

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to Rateify")
                    .font(.headline)

                NavigationLink(destination: SearchAlbumView()) {
                    Text("Go to Album Search")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
