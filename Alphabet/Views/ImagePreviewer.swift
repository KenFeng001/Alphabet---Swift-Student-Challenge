import SwiftUI

struct ImagePreviewer: View {
    var photos: [PhotoItem] // 传入的照片数组
    var selectedLetter: String // 当前字母
    var isPresented: Binding<Bool>

    var body: some View {
        GeometryReader { geometry in
            Color.clear // 透明背景用于检测点击
                .contentShape(Rectangle()) // 使整个区域可点击
                .onTapGesture {
                    isPresented.wrappedValue = false
                }
                .overlay {
                    VStack {
                        // 顶部导航栏
                        HStack {
                            Button(action: {
                                isPresented.wrappedValue = false
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black) // 改为黑色
                                    .padding()
                            }
                            
                            Spacer()
                            
                            Text(selectedLetter)
                                .foregroundColor(.black) // 改为黑色
                                .font(.title2)
                            
                            Spacer()
                            
                            // 为了保持对称添加一个占位视图
                            Color.clear
                                .frame(width: 44, height: 44)
                        }
                        .padding(.top, 20)
                        .background(Color.white.opacity(0.5)) // 半透明白色背景
                        
                        // 照片展示区域
                        TabView {
                            ForEach(photos, id: \.id) { photo in
                                if let uiImage = UIImage(data: photo.imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                        .contentShape(Rectangle())
                                        .allowsHitTesting(false) // 禁止照片区域的点击事件
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .background(Color.white.opacity(0.7)) // 主要内容区域的半透明白色背景
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
        }
        .background(Color.white.opacity(0.5)) // 整体的半透明白色背景
        .ignoresSafeArea()
        .transition(.opacity)
    }
}
