//
//  HomeView.swift
//  Rateify
//
//  Created by Antonio Odore on 10/12/24.
//

import SwiftUI

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
#Preview {
    HomeView()
}
