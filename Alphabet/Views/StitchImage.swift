import SwiftUI

struct StitchImage: View {
    let isAllLetters: Bool
    let typedText: String
    let stichedCollection: PhotoCollection
    
    // 计算要显示的照片
    private var photosToDisplay: [PhotoItem] {
        if isAllLetters {
            // 显示所有照片
            return stichedCollection.photos
        } else {
            // 只显示输入文字对应的照片
            let letters = Array(typedText.uppercased())
            return letters.compactMap { letter in
                stichedCollection.photos.first { $0.letter == String(letter) }
            }
        }
    }
    
    // 计算每行显示的图片数量
    private let columnsCount = 7
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 标题
                Text(isAllLetters ? "All Letters" : "Text: \(typedText)")
                    .font(.title)
                    .padding(.horizontal)
                
                // 图片网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: columnsCount), spacing: 4) {
                    ForEach(photosToDisplay, id: \.id) { photo in
                        if let uiImage = UIImage(data: photo.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width - 32 - CGFloat(columnsCount - 1) * 4) / CGFloat(columnsCount),
                                       height: (UIScreen.main.bounds.width - 32 - CGFloat(columnsCount - 1) * 4) / CGFloat(columnsCount))
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    StitchImage(isAllLetters: true, typedText: "", stichedCollection: PhotoCollection(name: "Test", expectedEndDate: Date()))
}
