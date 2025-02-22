import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query private var photoCollections: [PhotoCollection]
    var currentTab: Tab
    var onTabChange: (Tab) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Navigation(currentTab: currentTab, onTabChange: onTabChange)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(photoCollections) { collection in
                            Collection(photoCollection: collection)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

#Preview {
    CollectionView(currentTab: .collection, onTabChange: { _ in })
        .modelContainer(SampleData.previewContainer)
}
