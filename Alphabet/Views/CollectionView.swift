import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query private var photoCollections: [PhotoCollection]
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                ],
                spacing: 16
            ) {
                ForEach(photoCollections) { collection in
                    Collection(photoCollection: collection)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    CollectionView()
        .modelContainer(SampleData.previewContainer)
}
