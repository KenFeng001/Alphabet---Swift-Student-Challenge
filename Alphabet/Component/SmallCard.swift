import SwiftUI
import PhotosUI
import SwiftData
import UIKit  // 添加这个导入以解决 UIImage 未定义的问题

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
    var isStacked: Bool
    var showUnfinished: Bool
    
    private var letterPhotos: [PhotoItem] {
        photoItems.filter { $0.letter == letter }
    }
    
    var body: some View {
        Group {
            if !letterPhotos.isEmpty {
                VStack {
                    ZStack {
                        if letterPhotos.count > 1 && isStacked {
                            // 多张照片时，总是显示固定照片在最上层
                            let pinnedItem = letterPhotos.first(where: { $0.isPinned }) ?? letterPhotos[0]
                            if let pinnedImage = UIImage(data: pinnedItem.imageData) {
                                // 显示其他照片在底层
                                if let otherItem = letterPhotos.first(where: { $0 != pinnedItem }),
                                   let otherImage = UIImage(data: otherItem.imageData) {
                                    Image(uiImage: otherImage)
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
                        } else {
                            // 单张照片或未启用堆叠时显示第一张
                            if let firstImage = UIImage(data: letterPhotos[0].imageData) {
                                Image(uiImage: firstImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 132)
                                    .clipped()
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                        }
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