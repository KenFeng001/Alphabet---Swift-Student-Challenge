import SwiftUI

struct ViewfinderImagePreview: View {
    @Environment(\.dismiss) private var dismiss // 用于返回的环境变量
    var image: Image // 接收 Image 类型的数据
    
    var body: some View {
        ZStack {
            Color.black // 背景颜色
            
            GeometryReader { geometry in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width - 10, height: geometry.size.width - 10)
                    .cornerRadius(10)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
            }
            .padding(.top, 40) // 调整顶部间距
        }
        .navigationBarHidden(true) // 隐藏导航栏
        .ignoresSafeArea() // 忽略安全区域
    }
}

#Preview {
    ViewfinderImagePreview(image: Image(systemName: "photo"))
}
