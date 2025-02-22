import SwiftUI

struct SlidingCards: View {
    var photoItems: [PhotoItem]
    var currentCollection: PhotoCollection?
    var uncollectedLetters: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 40) {
                ForEach(uncollectedLetters, id: \.self) { letter in
                    Card(
                        title: letter,
                        description: "This is the letter \(letter)",
                        photoItems: photoItems,
                        currentCollection: currentCollection
                    )
                    .scrollTransition(.animated) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.8)
                            .scaleEffect(phase.isIdentity ? 1 : 0.9)
                    }
                }
                .frame(width: 337-40)
            }
            .scrollTargetLayout()
            .padding(.horizontal, 50)
        }
        .scrollTargetBehavior(.viewAligned)
    }
} 