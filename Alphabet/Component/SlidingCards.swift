import SwiftUI

struct SlidingCards: View {
    var photoItems: [PhotoItem]
    var currentCollection: PhotoCollection?
    var uncollectedLetters: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if uncollectedLetters.isEmpty {
                if let collection = currentCollection {
                    FinishedCards(currentCollection: collection)
                        .padding(.horizontal, 25)
                } else {
                    Text("No collection available.")
                }
            } else {
                HStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40) {
                    ForEach(uncollectedLetters, id: \.self) { letter in
                        Card(
                            title: letter,
                            currentCollection: currentCollection
                        )
                        .scrollTransition(.animated) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.8)
                                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                        }
                    }
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 445.5 : 297)
                }
                .scrollTargetLayout()
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 200 : 50)
            }
        }
        .scrollTargetBehavior(.viewAligned)
    }
} 

#Preview {
    SlidingCards(photoItems: SampleData.photos, currentCollection: SampleData.collection, uncollectedLetters: [])
}
