import SwiftUI

struct ImagePreviewer: View {
    var photos: [PhotoItem] // 传入的照片数组
    var selectedLetter: String // 当前字母

    var body: some View {
        ZStack {
            Color.black.opacity(0.5) // 半透明背景
                .ignoresSafeArea()

            TabView {
                ForEach(photos, id: \.id) { photo in
                    if let uiImage = UIImage(data: photo.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .padding()
        }
        .navigationTitle(selectedLetter) // 显示当前字母
        .navigationBarTitleDisplayMode(.inline)
    }
}
