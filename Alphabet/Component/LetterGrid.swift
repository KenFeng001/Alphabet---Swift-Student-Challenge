import SwiftUI

struct LetterGrid: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    var photoItems: [PhotoItem]
    var currentCollection: PhotoCollection?
    @Binding var showingImagePreview: Bool
    @Binding var selectedPreviewPhotos: [PhotoItem]
    @Binding var selectedPreviewLetter: String
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(letters.indices, id: \.self) { index in
                SmallCard(
                    letter: String(letters[index]),
                    photoItems: photoItems,
                    showingImagePreview: $showingImagePreview,
                    selectedPreviewPhotos: $selectedPreviewPhotos,
                    selectedPreviewLetter: $selectedPreviewLetter,
                    currentCollection: currentCollection
                )
            }
        }
        .padding()
    }
} 