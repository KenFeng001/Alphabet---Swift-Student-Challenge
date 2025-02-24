import SwiftUI
import SwiftData
import UIKit  // 添加 UIKit 导入以使用 UIImage

struct ExportGrid: View {
    var collection: PhotoCollection
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    // 按字母顺序排序的照片
    private var sortedPhotos: [PhotoItem] {
        collection.photos.sorted { $0.letter < $1.letter }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(sortedPhotos) { photo in
                if let uiImage = UIImage(data: photo.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .overlay(alignment: .bottomTrailing) {
                            // 右下角显示字母
                            Text(photo.letter)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(4)
                                .background {
                                    Rectangle()
                                        .fill(.black.opacity(0.6))
                                }
                        }
                }
            }
        }
        .padding(4)
    }
}

#Preview {
    ExportGrid(collection: SampleData2.collection)
        .modelContainer(SampleData2.previewContainer)
}

