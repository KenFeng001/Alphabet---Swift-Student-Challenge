import SwiftUI

struct StitchImage: View {
    let isAllLetters: Bool
    let typedText: String
    let stichedCollection: PhotoCollection
    
    // Calculate photos to display
    private var photosToDisplay: [PhotoItem] {
        if isAllLetters {
            // Display all photos
            return stichedCollection.photos
        } else {
            // Only display photos corresponding to input text
            let letters = Array(typedText.uppercased())
            return letters.compactMap { letter in
                stichedCollection.photos.first { $0.letter == String(letter) }
            }
        }
    }
    
    // Calculate number of images to display per row
    private let columnsCount = 7
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(isAllLetters ? "All Letters" : "Text: \(typedText)")
                    .font(.title)
                    .padding(.horizontal)
                
                // Image grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: columnsCount), spacing: 4) {
                    ForEach(photosToDisplay, id: \.id) { photo in
                        if let uiImage = UIImage(data: photo.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width - 32 - CGFloat(columnsCount - 1) * 4) / CGFloat(columnsCount),
                                       height: (UIScreen.main.bounds.width - 32 - CGFloat(columnsCount - 1) * 4) / CGFloat(columnsCount))
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    StitchImage(isAllLetters: true, typedText: "", stichedCollection: PhotoCollection(name: "Test", expectedEndDate: Date()))
}
