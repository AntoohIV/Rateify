import SwiftUI
import MusicKit
import SwiftData
import PhotosUI

struct ProfileView: View {
    // Nome dell'utente
    @State private var userName = "UserName"
    @State private var selectedImage: UIImage? // Immagine selezionata dall'utente
    @State private var isImagePickerPresented = false // Stato per mostrare l'Image Picker
    
    // Query per recuperare le canzoni e gli album votati dal database
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
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4)) // Aggiunta bordatura blu
                            .shadow(radius: 10) // Ombra per l'immagine
                            .clipped()
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    }
                    
                    // Nome dell'utente
                    TextField("UserName", text: $userName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .foregroundColor(.primary)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Stile del TextField
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
                                Divider() // Separatore tra le canzoni
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)

                // Sezione degli album votati
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
                                    VStack(alignment: .leading) {
                                        Text(album.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text("Artista: \(album.artistName)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    // Mostra il voto come stelle per l'album
                                    HStack {
                                        ForEach(1...5, id: \.self) { star in
                                            Image(systemName: star <= album.rating ? "star.fill" : "star")
                                                .foregroundColor(star <= album.rating ? .yellow : .gray)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                Divider() // Separatore tra gli album
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
        .background(Color(.systemGray6)) // Sfondo grigio chiaro
    }
}

// Image Picker per selezionare un'immagine dalla libreria
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: RatedSong.self) // Aggiungi il container SwiftData per RatedSong
        .modelContainer(for: RatedAlbum.self) // Aggiungi il container SwiftData per RatedAlbum
}
