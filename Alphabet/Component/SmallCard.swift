import SwiftUI
import PhotosUI
import SwiftData

struct SmallCard: View {
    let letter: String
    var photoItems: [PhotoItem]
    @State private var showPhotoPicker = false
    @Binding var showingImagePreview: Bool
    @Binding var selectedPreviewPhotos: [PhotoItem]
    @Binding var selectedPreviewLetter: String
    @Environment(\.modelContext) private var modelContext

    var currentCollection: PhotoCollection? {
        photoItems.first?.collection
    }
    
    var body: some View {
        Group {
            if let latestItem = photoItems
                .filter({ $0.letter == letter })
                .sorted(by: { $0.timestamp > $1.timestamp })
                .first,
               let uiImage = UIImage(data: latestItem.imageData) {
                VStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 132)
                        .clipped()
                        .background(Color.gray)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedPreviewPhotos = photoItems.filter { $0.letter == letter }
                            selectedPreviewLetter = letter
                            showingImagePreview = true
                        }
                        .contextMenu {
                            Button(action: {
                                showPhotoPicker = true
                            }) {
                                Label("更换照片", systemImage: "photo")
                            }
                            
                            NavigationLink(destination: ViewfinderView(selectedLetter: letter, currentCollection: currentCollection)) {
                                Label("拍摄新照片", systemImage: "camera.fill")
                            }
                        }
                    Text(letter.uppercased() + letter.lowercased())
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .padding(.top, 4)
                }
            } else {
                // 没有照片的情况
                VStack {
                    Menu {
                        Button(action: {
                            showPhotoPicker = true
                        }) {
                            Label("上传照片", systemImage: "photo")
                        }
                        
                        NavigationLink(destination: ViewfinderView(selectedLetter: letter, currentCollection: currentCollection)) {
                            Label("拍摄照片", systemImage: "camera.fill")
                        }
                    } label: {
                        Image("smallcardbg")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 132)
                            .cornerRadius(10)
                    }
                    
                    Text(letter.uppercased() + letter.lowercased())
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .padding(.top, 4)
                }
            }
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: Binding(
                get: { nil },
                set: { newItem in
                    if let newItem {
                        loadImage(from: newItem)
                    }
                }
            ),
            matching: .images
        )
    }
    
    // 加载选中的照片
    private func loadImage(from item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let currentCollection {
                await MainActor.run {
                    let photo = PhotoItem(
                        letter: letter,
                        imageData: data,
                        collection: currentCollection
                    )
                    modelContext.insert(photo)
                }
            }
        }
    }
} 