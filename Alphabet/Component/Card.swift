import SwiftUI

struct Card: View {
    var title: String
    var description: String
    var photoItems: [PhotoItem]
    var currentCollection: PhotoCollection?  // 添加 currentCollection 参数
    @State private var isLetterVisible = false
    @State private var isBackdropVisible = false
    @State private var isTextVisible = false
    @State private var randomQuote: MotivationalQuote
    
    init(title: String, description: String, photoItems: [PhotoItem], currentCollection: PhotoCollection?) {
        self.title = title
        self.description = description
        self.photoItems = photoItems
        self.currentCollection = currentCollection
        _randomQuote = State(initialValue: quotes.randomElement() ?? MotivationalQuote(quote: "Look at the world differently.", author: "Unknown"))
    }
    
    var body: some View {
        if let latestItem = photoItems
            .filter({ $0.letter == title })
            .sorted(by: { $0.timestamp > $1.timestamp })
            .first,
           let uiImage = UIImage(data: latestItem.imageData) {
            // 有照片的情况保持不变
            ZStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 337, height: 449)
            }
            .clipped()
            .cornerRadius(20)
            .shadow(radius: 10)
        } else {
            // 没有照片的情况
            ZStack {
                Image("cardbackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 337, height: 449)
                
                VStack(spacing: 8) {
                    VStack {
                        Image(systemName: "eyes")
                        Text("Looking for")
                            .font(.system(size: 24))
                    }
                    
                    ZStack {
                        Image("letterbackdrop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .scaleEffect(isBackdropVisible ? 1 : 0.5)
                            .opacity(isBackdropVisible ? 1 : 0)
                        
                        Text(title)
                            .font(.system(size: 100, weight: .bold))
                            .foregroundColor(.black)
                            .scaleEffect(isLetterVisible ? 1 : 0.5)
                            .opacity(isLetterVisible ? 1 : 0)
                    }
                    
                    Text(randomQuote.quote)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 14)
                        .opacity(isTextVisible ? 1 : 0)
                        .scaleEffect(isTextVisible ? 1 : 0.8)

                    Text("- \(randomQuote.author)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .opacity(isTextVisible ? 1 : 0)
                        .scaleEffect(isTextVisible ? 1 : 0.8)

                    HStack {
                        NavigationLink(destination: ViewfinderView(selectedLetter: title, currentCollection: currentCollection)) {
                            Image("takeimage")
                        }
                        Button(action: {
                            // 处理导入按钮的点击事件
                        }) {
                            Image("import")
                        }
                    }
                    .padding(.leading, 140)
                    .padding(.top, 14)

                }
            }
            .frame(width: 349, height: 461)
            .clipped()
            .cornerRadius(20)
            // .shadow(radius: 10)
            .onAppear {
                // 背景动画
                withAnimation(.easeOut(duration: 0.6)) {
                    isBackdropVisible = true
                }
                
                // 字母动画
                withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                    isLetterVisible = true
                }
                
                // 文字动画
                withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
                    isTextVisible = true
                }
            }
            .onDisappear {
                // 重置所有状态
                isBackdropVisible = false
                isLetterVisible = false
                isTextVisible = false
            }
        }
    }
}
