import SwiftUI

struct ImagePreviewer: View {
    var photos: [PhotoItem] // 传入的照片数组
    var selectedLetter: String // 当前字母
    var isPresented: Binding<Bool>
    
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0
    
    private func calculateDismissProgress(_ translation: CGSize) -> CGFloat {
        let progress = sqrt(
            pow(translation.height, 2) + 
            pow(translation.width, 2)
        ) / UIScreen.main.bounds.height
        return min(max(progress, 0), 1)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部导航栏
            HStack {
                Button {
                    isPresented.wrappedValue = false
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("TFL")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(selectedLetter)
                    .font(.system(size: 32))
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 16)
            
            // 图片展示区域
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
            
            // 底部工具栏
            HStack(spacing: 40) {
                Button {
                    // 上传功能
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                }
                
                Button {
                    // 删除功能
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 20)
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
        .ignoresSafeArea()
    }
}
