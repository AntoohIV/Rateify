import SwiftUI
import MusicKit
import SwiftData
import PhotosUI

struct ProfileView: View {
    @State private var userName = UserDefaults.standard.string(forKey: "userName") ?? "UserName"
    @State private var selectedImage: UIImage? = {
        if let imageData = UserDefaults.standard.data(forKey: "userImage") {
            return UIImage(data: imageData)
        }
        return nil
    }()
    @State private var isImagePickerPresented = false

    @Query var ratedSongs: [RatedSong]
    @Query var ratedAlbums: [RatedAlbum]

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Sezione per l'immagine e nome dell'utente
                VStack {
                    // Immagine utente con Image Picker
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    } else {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    }
                    // Nome dell'utente
                    TextField("UserName", text: $userName, onCommit: saveUserName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .foregroundColor(.primary)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.top, 20)

                // Sezione delle canzoni votate
                VStack(alignment: .leading, spacing: 15) {
                    Text("Rated Songs")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.leading)
                    
                    if ratedSongs.isEmpty {
                        Text("No songs voted.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                    } else {
                        ForEach(ratedSongs) { song in
                            VStack(alignment: .leading) {
                                HStack {
                                    // Mostra l'artwork della canzone
                                    if let artworkURL = song.artworkURL {
                                        AsyncImage(url: artworkURL) { imagePhase in
                                            if let image = imagePhase.image {
                                                // Mostra l'immagine quando caricata
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(10)
                                            } else {
                                                // Mostra un placeholder finché l'immagine non è caricata
                                                ProgressView()
                                                    .frame(width: 50, height: 50)
                                            }
                                        }
                                    } else {
                                        // Mostra un'immagine di default se non c'è un artwork
                                        Image(systemName: "music.note")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(10)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(song.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text("Artista: \(song.artistName)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    // Mostra il voto come stelle
                                    HStack {
                                        ForEach(1...5, id: \.self) { star in
                                            Image(systemName: star <= song.rating ? "star.fill" : "star")
                                                .foregroundColor(star <= song.rating ? .yellow : .gray)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                Divider()
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)

                // Sezione degli album votati (non modificata)
                VStack(alignment: .leading, spacing: 15) {
                    Text("Rated Albums")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.leading)

                    if ratedAlbums.isEmpty {
                        Text("No albums rated.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                    } else {
                        ForEach(ratedAlbums) { album in
                            VStack(alignment: .leading) {
                                HStack {
                                    // Mostra l'artwork dell'album
                                    if let artworkURL = album.artworkURL {
                                        AsyncImage(url: artworkURL) { imagePhase in
                                            if let image = imagePhase.image {
                                                // Mostra l'immagine quando caricata
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(10)
                                            } else {
                                                // Mostra un placeholder finché l'immagine non è caricata
                                                ProgressView()
                                                    .frame(width: 50, height: 50)
                                            }
                                        }
                                    } else {
                                        // Mostra un'immagine di default se non c'è un artwork
                                        Image(systemName: "music.note")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(10)
                                            .foregroundColor(.blue)
                                    }

                                    VStack(alignment: .leading) {
                                        Text(album.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text("Artista: \(album.artistName)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()

                                    // Mostra il voto come stelle
                                    HStack {
                                        ForEach(1...5, id: \.self) { star in
                                            Image(systemName: star <= album.rating ? "star.fill" : "star")
                                                .foregroundColor(star <= album.rating ? .yellow : .gray)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                Divider()
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)

            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, onImagePicked: saveImage)
            }
        }
        .background(Color(.systemGray6))
    }

    private func saveUserName() {
        UserDefaults.standard.set(userName, forKey: "userName")
    }

    private func saveImage(image: UIImage) {
        selectedImage = image
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "userImage")
        }
    }
}
