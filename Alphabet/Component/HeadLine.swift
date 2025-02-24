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
        return "Empty"
    }
    
    // 获取当前选中的collection
    private var currentCollection: PhotoCollection? {
        photoCollections.first { $0.id == selectedCollectionId }
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
            
            if photoCollections.isEmpty {
                Button(action: {
                    showingCreateCollection = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                        Text("Create Collection")
                            .font(.system(size: 32, weight: .bold))
                    }
                    .foregroundColor(.gray)
                }
            } else {
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
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20))
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateCollection) {
            CreateCollectionView { newId in
                selectedCollectionId = newId
            }
        }
        .onChange(of: photoCollections) { oldValue, newValue in
            // 如果当前选中的 collection 不存在，选择第一个 collection
            if selectedCollectionId == nil || !newValue.contains(where: { $0.id == selectedCollectionId }) {
                selectedCollectionId = newValue.first?.id
            }
        }
    }
} 
