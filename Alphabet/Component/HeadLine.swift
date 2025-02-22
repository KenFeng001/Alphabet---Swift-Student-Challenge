import SwiftUI
import SwiftData

struct HeadLine: View {
    @Query private var photoCollections: [PhotoCollection]
    @Binding var selectedCollectionId: UUID?
    @State private var showingCreateCollection = false
    var isScrolledPast: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                Text(isScrolledPast ? "Found alphabet in" : "Unfound alphabet in")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            
            Menu {
                ForEach(photoCollections) { collection in
                    Button(collection.name) {
                        selectedCollectionId = collection.id
                    }
                }
                
                Divider()
                
                Button(action: {
                    showingCreateCollection = true
                }) {
                    Label("创建新集合", systemImage: "plus.circle")
                }
            } label: {
                HStack {
                    Text(photoCollections.first(where: { $0.id == selectedCollectionId })?.name ?? "示例集合")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20))
                }
            }
        }
        .sheet(isPresented: $showingCreateCollection) {
            CreateCollectionView()
        }
    }
} 