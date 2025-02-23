import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query private var photoCollections: [PhotoCollection]
    var currentTab: Tab
    var onTabChange: (Tab) -> Void
    @State private var scrollProgress: CGFloat = 0.0
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Color.clear
                        .frame(height: 60)
                        
                    ForEach(photoCollections) { collection in
                        NavigationLink {
                            CollectionDetailView(displayedCollection: collection)
                        } label: {
                            Collection(photoCollection: collection)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .background(GeometryReader { geo -> Color in
                    let offset = geo.frame(in: .global).minY
                    DispatchQueue.main.async {
                        scrollProgress = -offset / 100
                    }
                    return Color.clear
                })
            }
            .overlay(alignment: .top) {
                Navigation(currentTab: currentTab, onTabChange: onTabChange)
                    .padding(.horizontal, 16)
                    .background {
                        Rectangle()
                            .fill(.white)
                            .opacity(0.8)
                            .blur(radius: 20)
                            .ignoresSafeArea()
                    }
                    .overlay(alignment: .bottom) {
                        LinearGradient(
                            colors: [.white.opacity(0), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 40)
                        .offset(y: 20)
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
