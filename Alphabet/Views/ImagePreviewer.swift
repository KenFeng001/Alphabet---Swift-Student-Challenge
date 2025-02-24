import SwiftUI
import SwiftData
import UIKit

struct ImagePreviewer: View {
    var photos: [PhotoItem]
    var selectedLetter: String
    var isPresented: Binding<Bool>
    
    @Environment(\.modelContext) private var modelContext
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var currentPage = 0
    @State private var currentPhotos: [PhotoItem]
    
    init(photos: [PhotoItem], selectedLetter: String, isPresented: Binding<Bool>) {
        self.photos = photos
        self.selectedLetter = selectedLetter
        self.isPresented = isPresented
        
        // 初始化时，如果没有固定的照片，将最新的照片设为固定
        let pinnedPhoto = photos.first(where: { $0.isPinned })
        if pinnedPhoto == nil, let latestPhoto = photos.max(by: { $0.timestamp < $1.timestamp }) {
            _currentPhotos = State(initialValue: photos)
            latestPhoto.isPinned = true
        } else {
            _currentPhotos = State(initialValue: photos)
        }
    }
    
    private func calculateDismissProgress(_ translation: CGSize) -> CGFloat {
        let progress = sqrt(
            pow(translation.height, 2) + 
            pow(translation.width, 2)
        ) / UIScreen.main.bounds.height
        return min(max(progress, 0), 1)
    }
    
    private func deleteCurrentPhoto() {
        guard currentPage < currentPhotos.count else { return }
        let photoToDelete = currentPhotos[currentPage]
        
        // 如果是最后一张照片
        if currentPhotos.count == 1 {
            modelContext.delete(photoToDelete)
            isPresented.wrappedValue = false
            return
        }
        
        // 如果不是最后一张照片
        // 先调整当前页码，确保不会越界
        if currentPage == currentPhotos.count - 1 {
            currentPage -= 1
        }
        
        // 从数组中移除照片
        if let index = currentPhotos.firstIndex(where: { $0.id == photoToDelete.id }) {
            currentPhotos.remove(at: index)
        }
        
        // 如果删除的是固定的照片，将最新的照片设为固定
        if photoToDelete.isPinned {
            if let latestPhoto = currentPhotos.max(by: { $0.timestamp < $1.timestamp }) {
                latestPhoto.isPinned = true
            }
        }
        
        // 删除数据库中的照片
        modelContext.delete(photoToDelete)
    }
    
    private func pinCurrentPhoto() {
        guard currentPage < currentPhotos.count else { return }
        let photoToPin = currentPhotos[currentPage]
        
        // 取消其他照片的固定状态
        for photo in currentPhotos where photo.isPinned {
            photo.isPinned = false
        }
        
        // 设置当前照片为固定状态
        photoToPin.isPinned = true
    }
    
    private func shareCurrentPhoto() {
        guard currentPage < currentPhotos.count,
              let image = UIImage(data: currentPhotos[currentPage].imageData) else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        // 获取当前的 UIWindow
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            // 在 iPad 上需要设置 popoverPresentationController
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = window
                popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 图片展示区域
            TabView(selection: $currentPage) {
                ForEach(Array(currentPhotos.enumerated()), id: \.element.id) { index, photo in
                    if let uiImage = UIImage(data: photo.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(3/4, contentMode: .fit)
                            .cornerRadius(20)
                            .padding(.horizontal, 20)
                            .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .onAppear {
                // 自定义 PageControl 的外观
                UIPageControl.appearance().currentPageIndicatorTintColor = .black
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
            }
            
            // 底部工具栏
            HStack(spacing: 40) {
                Button {
                    pinCurrentPhoto()
                } label: {
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: currentPhotos[currentPage].isPinned ? "pin.fill" : "pin")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        )
                }
                
                Button {
                    deleteCurrentPhoto()
                } label: {
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: "trash")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .padding(.bottom, 97)
        .toolbar {
      
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    shareCurrentPhoto()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                }
            }
        }
        .background(Color.white)
        .offset(x: offset.width, y: offset.height)
        .scaleEffect(scale)
        .opacity(opacity)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    let translation = gesture.translation
                    offset = translation
                    
                    let progress = calculateDismissProgress(translation)
                    opacity = 1.0 - progress * 0.5
                    scale = 1.0 - progress * 0.2
                }
                .onEnded { gesture in
                    let translation = gesture.translation
                    let progress = calculateDismissProgress(translation)
                    let velocity = gesture.predictedEndLocation.y - gesture.location.y
                    
                    if progress > 0.25 || abs(velocity) > 1000 {
                        withAnimation(.easeOut(duration: 0.2)) {
                            let velocityMultiplier: CGFloat = 0.5
                            offset.width += gesture.velocity.width * velocityMultiplier
                            offset.height += gesture.velocity.height * velocityMultiplier
                            opacity = 0
                            scale = 0.5
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isPresented.wrappedValue = false
                        }
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            offset = .zero
                            opacity = 1.0
                            scale = 1.0
                        }
                    }
                }
        )
    }
}

#Preview {
    ImagePreviewer(photos: SampleData.photos, selectedLetter: "A", isPresented: .constant(true))
        .modelContainer(SampleData.previewContainer)
}