import SwiftUI
import PhotosUI
import SwiftData

struct SmallCard: View {
    let letter: String
    var photoItems: [PhotoItem]
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @Binding var showingImagePreview: Bool
    @Binding var selectedPreviewPhotos: [PhotoItem]
    @Binding var selectedPreviewLetter: String
    @Environment(\.modelContext) private var modelContext

    var currentCollection: PhotoCollection?
    
    private var letterPhotos: [PhotoItem] {
        photoItems.filter { $0.letter == letter }
    }
    
    var body: some View {
        Group {
            if let pinnedItem = letterPhotos.first(where: { $0.isPinned }),
               let pinnedImage = UIImage(data: pinnedItem.imageData) {
                VStack {
                    ZStack {
                        // 如果有其他照片，显示在底层
                        if let secondItem = letterPhotos.first(where: { !$0.isPinned }),
                           let secondImage = UIImage(data: secondItem.imageData) {
                            Image(uiImage: secondImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 132)
                                .clipped()
                                .background(Color.gray)
                                .cornerRadius(10)
                                .offset(x: 4, y: -5)
                                .rotationEffect(.degrees(3))
                                .opacity(0.5)
                        }
                        
                        // 固定的照片显示在上层
                        Image(uiImage: pinnedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 132)
                            .clipped()
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    .onTapGesture {
                        selectedPreviewPhotos = letterPhotos
                        selectedPreviewLetter = letter
                        showingImagePreview = true
                    }
                    .contextMenu {
                        Button(action: {
                            showPhotoPicker = true
                        }) {
                            Label("更换照片", systemImage: "photo")
                        }
                        
                        Button(action: {
                            showCamera = true
                        }) {
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
                        
                        Button(action: {
                            showCamera = true
                        }) {
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
        .navigationDestination(isPresented: $showCamera) {
            ViewfinderView(
                selectedLetter: letter,
                currentCollection: currentCollection
            )
        }
    }
    
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