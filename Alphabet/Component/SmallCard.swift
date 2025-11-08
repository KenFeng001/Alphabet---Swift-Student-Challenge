import SwiftUI
import PhotosUI
import SwiftData
import UIKit  // 添加这个导入以解决 UIImage 未定义的问题

struct SmallCard: View {
    let letter: String
    var photoItems: [PhotoItem]
    @State private var showPhotoPicker = false
    @Binding var showingImagePreview: Bool
    @Binding var selectedPreviewPhotos: [PhotoItem]
    @Binding var selectedPreviewLetter: String
    @Environment(\.modelContext) private var modelContext
    
    var currentCollection: PhotoCollection?
    var isStacked: Bool
    var showUnfinished: Bool
    var onCameraRequest: ((String) -> Void)?
    
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
                                        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 150 : 100, 
                                               height: UIDevice.current.userInterfaceIdiom == .pad ? 198 : 132)
                                        .clipped()
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                        .offset(x: UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4, 
                                               y: UIDevice.current.userInterfaceIdiom == .pad ? -7.5 : -5)
                                        .rotationEffect(.degrees(3))
                                        .opacity(0.5)
                                }
                                
                                // 固定的照片显示在上层
                                Image(uiImage: pinnedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 150 : 100, 
                                           height: UIDevice.current.userInterfaceIdiom == .pad ? 198 : 132)
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
                                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 150 : 100, 
                                           height: UIDevice.current.userInterfaceIdiom == .pad ? 198 : 132)
                                    .clipped()
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .onTapGesture {
                        selectedPreviewPhotos = isStacked ? letterPhotos : photoItems
                        selectedPreviewLetter = letter
                        showingImagePreview = true
                    }
                    .contextMenu {
                        Button(action: {
                            showPhotoPicker = true
                        }) {
                            Label("Replace Photo", systemImage: "photo")
                        }
                        
                        Button(action: {
                            onCameraRequest?(letter)
                        }) {
                            Label("Take New Photo", systemImage: "camera.fill")
                        }
                    }
                    
                    Text(letter.uppercased() + letter.lowercased())
                        .fontWeight(.bold)
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 21 : 14))
                        .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4)
                }
            } else {
                // Case when no photos exist
                VStack {
                    Menu {
                        Button(action: {
                            showPhotoPicker = true
                        }) {
                            Label("Upload Photo", systemImage: "photo")
                        }
                        
                        Button(action: {
                            onCameraRequest?(letter)
                        }) {
                            Label("Take Photo", systemImage: "camera.fill")
                        }
                    } label: {
                        Image("smallcardbg")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 150 : 100, 
                                   height: UIDevice.current.userInterfaceIdiom == .pad ? 198 : 132)
                            .cornerRadius(10)
                    }
                    
                    Text(letter.uppercased() + letter.lowercased())
                        .fontWeight(.bold)
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 21 : 14))
                        .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4)
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