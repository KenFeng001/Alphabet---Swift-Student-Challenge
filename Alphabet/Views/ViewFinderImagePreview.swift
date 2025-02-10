import SwiftUI
import SwiftData
import Photos // 添加 Photos 框架

struct ViewfinderImagePreview: View {
    @Environment(\.dismiss) private var dismiss // 用于返回的环境变量
    @Environment(\.modelContext) private var modelContext
    var thumbNailImage: Image
    var imageData: Data // 接收 Image 类型的数据
    var selectedLetter: String // 接收字母数据
    var currentCollection: PhotoCollection? // 新增参数
    
    var body: some View {
        ZStack {
            Color.black // 背景颜色
            
            GeometryReader { geometry in
                VStack {
                    // 显示选中的字母
                    Text(selectedLetter)
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    thumbNailImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width - 10, height: geometry.size.width - 10)
                        .cornerRadius(10)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            
            // 自定义返回按钮
            VStack {
                HStack {
                    Button(action: {
                        dismiss() // 返回操作
                    }) {
                        Image(systemName: "chevron.left") // 使用系统的 chevron 图标
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.5))) // 半透明黑色背景
                    }
                    Spacer()
                }
                Spacer()
                
                // 添加保存按钮
                Button(action: {
                    saveImage() // 调用保存图像的函数
                    dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30) // 添加底部间距
            }
            .padding(.top, 40) // 调整顶部间距
        }
        .navigationBarHidden(true) // 隐藏导航栏
        .ignoresSafeArea() // 忽略安全区域
    }

    // 修改保存图像的函数
    private func saveImage() {
        // 保存到 SwiftData
        let photoItem = PhotoItem(
            letter: selectedLetter, 
            imageData: imageData,
            collection: currentCollection
        )
        modelContext.insert(photoItem)
        
        // 保存到相册
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges {
                // 创建相册请求
                let createAssetRequest = PHAssetCreationRequest.forAsset()
                createAssetRequest.addResource(with: .photo, data: imageData, options: nil)
            } completionHandler: { success, error in
                if success {
                    print("Successfully saved to photo library")
                } else if let error = error {
                    print("Error saving to photo library: \(error.localizedDescription)")
                }
            }
        }
    }
}

// 添加 Image 扩展来支持转换为 UIImage
extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// 添加预览
#Preview {
    ViewfinderImagePreview(
        thumbNailImage: Image("IMG_5719"),
        imageData: Data(), // 使用空的 Data 作为预览
        selectedLetter: "A",
        currentCollection: nil
    )
}
