import SwiftUI
import SwiftData

struct HeadLine: View {
    @Query private var photoCollections: [PhotoCollection]
    @Binding var selectedCollectionId: UUID?
    @State private var showingCreateCollection = false
    var isScrolledPast: Bool
    
    // 获取当前选中的集合名称
    private var currentCollectionName: String {
        if let selectedId = selectedCollectionId,
           let collection = photoCollections.first(where: { $0.id == selectedId }) {
            return collection.name
        }
        return SampleData.collection.name
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                if isScrolledPast {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Text("Found alphabet in")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Text("Unfound alphabet in")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isScrolledPast)
            
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
                    Text(currentCollectionName)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20))
                }
            }
        }
        .sheet(isPresented: $showingCreateCollection) {
            CreateCollectionView { newId in
                selectedCollectionId = newId
            }
        }
        .onAppear {
            if selectedCollectionId == nil {
                selectedCollectionId = SampleData.collection.id
            }
        }
    }
} 
