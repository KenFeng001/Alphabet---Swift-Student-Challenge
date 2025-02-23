import SwiftUI
import SwiftData

struct ViewfinderImagePreview: View {
    @Environment(\.dismiss) private var dismiss // 用于返回的环境变量
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    var thumbNailImage: Image
    var imageData: Data // 接收 Image 类型的数据
    var selectedLetter: String // 接收字母数据
    var currentCollection: PhotoCollection? // 新增参数
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部字母显示
            Text("\(selectedLetter);f")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 40)
            
            // 图片预览
            thumbNailImage
                .resizable()
                .scaledToFill()
                .aspectRatio(3/4, contentMode: .fit)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            // 底部控制栏
            HStack {
                // 返回按钮
                Button(action: {
                    dismiss()
                }) {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        )
                }
                
                Spacer()
                
                // 保存按钮
                Button(action: {
                    saveImage()
                    // 直接关闭所有页面回到 Current_challenge
                    dismiss()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Saved to \(selectedLetter)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(22)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
    }

    // 保存图像的函数
    private func saveImage() {
        let photoItem = PhotoItem(
            letter: selectedLetter, 
            imageData: imageData,
            collection: currentCollection
        )
        modelContext.insert(photoItem)
        currentCollection?.pinPhotoItem(for: selectedLetter, photoItem: photoItem)
        print("Saving image with letter: \(selectedLetter) to collection: \(currentCollection?.name ?? "none")")
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
        thumbNailImage: Image("Y"),
        imageData: Data(), // 使用空的 Data 作为预览
        selectedLetter: "A",
        currentCollection: nil
    )
}
