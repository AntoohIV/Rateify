//
//  ExploreView.swift
//  Rateify
//
//  Created by Antonio Odore on 10/12/24.
//

import SwiftUI

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

#Preview {
    ExploreView()
}
