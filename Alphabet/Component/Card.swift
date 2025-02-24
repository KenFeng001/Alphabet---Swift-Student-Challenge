import SwiftUI

struct Card: View {
    var title: String
    var currentCollection: PhotoCollection?  // 添加 currentCollection 参数
    @State private var isLetterVisible = false
    @State private var isBackdropVisible = false
    @State private var isTextVisible = false
    @State private var randomQuote: MotivationalQuote
    @State private var selectedBackdrop: Int
    @State private var showViewfinder = false  // 添加状态变量来控制导航
    
    init(title: String, currentCollection: PhotoCollection?) {
        self.title = title
        self.currentCollection = currentCollection
        _randomQuote = State(initialValue: quotes.randomElement() ?? MotivationalQuote(quote: "Look at the world differently.", author: "Unknown"))
        _selectedBackdrop = State(initialValue: Int.random(in: 0...8))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("cardbackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 505.5 : 337, 
                           height: UIDevice.current.userInterfaceIdiom == .pad ? 673.5 : 449)
                
                VStack(spacing: 0) {
                    VStack {
                        Image("Eyes")

                        Text("Looking for")
                            .font(.system(size: 24))
                    }
                    
                    ZStack {
                        Image("LetterBackDrop-\(selectedBackdrop)")
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
                            .frame(maxWidth: .infinity, alignment: .center)
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
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        Button(action: {
                            showViewfinder = true  // 点击时设置状态为 true
                        }) {
                            Image("takeimage")
                        }
                        Button(action: {
                            // 处理导入按钮的点击事件
                        }) {
                            Image("import")
                        }
                    }
                    .padding(.leading, 140)
                    .padding(.top, 30)

                }
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 523.5 : 349, 
                   height: UIDevice.current.userInterfaceIdiom == .pad ? 691.5 : 461)
            .clipped()
            .cornerRadius(20)
            .navigationDestination(isPresented: $showViewfinder) {
                ViewfinderView(selectedLetter: title, currentCollection: currentCollection)
            }
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

#Preview {
    Card(title: "A", currentCollection: SampleData.collection)
}
