import SwiftUI
struct Navigation: View {
    var body: some View {
        HStack {
            Button(action: {
                // 处理 Collection 按钮的点击事件
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(.gray)
                    Text("Collection")
                        .foregroundColor(.gray)
                }
            }
              
            // 右侧的图标
            Button(action: {
                // 处理 Finding 按钮的点击事件
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Text("Finding")
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.leading, 20)
    }
}
