//
//  Current_challenge.swift
//  Alphabet
//
//  Created by Zile Feng on 07/02/2025.
//
import SwiftUI
import SwiftData
import PhotosUI

struct Current_challenge: View {
    @Query private var photoCollections: [PhotoCollection]
    @State private var showingCreateCollection = false
    @State private var selectedCollectionId: UUID?
    @State private var scrollProgress: CGFloat = 0.0 // 添加滚动进度状态
    
    // 获取当前选中的collection
    var currentCollection: PhotoCollection? {
        photoCollections.first { $0.id == selectedCollectionId } ?? photoCollections.first
    }
    
    // 获取当前collection的照片
    private var currentPhotos: [PhotoItem] {
        currentCollection?.photos ?? []
    }

    private var uncollectedLetters: [String] {
        currentCollection?.uncollectedLetters ?? []
    }
    
    var body: some View {
        VStack(spacing: 38) {
            Navigation() // 固定在顶部
            
            VStack(spacing: 20) {
                HStack {
                    HeadLine(
                        selectedCollectionId: $selectedCollectionId,
                        isScrolledPast: scrollProgress > 0.3 // 传递滚动状态
                    )
                    Spacer()
                    ProgressBar(currentCollection: currentCollection)
                }
                .padding(.leading)
            }
            
            ScrollView {
                SlidingCards(photoItems: currentPhotos, currentCollection: currentCollection, uncollectedLetters: uncollectedLetters)
                        .frame(height: 461)
                VStack {

                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Image(systemName: "sparkle.magnifyingglass")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    LetterGrid(photoItems: currentPhotos)
                }
                .background(GeometryReader { geo -> Color in
                    DispatchQueue.main.async {
                        let offset = -geo.frame(in: .named("scroll")).origin.y
                        let contentHeight = geo.size.height - UIScreen.main.bounds.height
                        scrollProgress = contentHeight > 0 ? offset / contentHeight : 0
                    }
                    return Color.clear
                })
            }
            .coordinateSpace(name: "scroll")
        }
        .sheet(isPresented: $showingCreateCollection) {
            CreateCollectionView()
        }
        .onChange(of: photoCollections) { oldValue, newValue in
            // 如果是第一次加载collections，自动选择第一个
            if selectedCollectionId == nil && !newValue.isEmpty {
                selectedCollectionId = newValue.first?.id
            }
        }
    }
}

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

struct HeadLine: View {
    @Query private var photoCollections: [PhotoCollection]
    @Binding var selectedCollectionId: UUID?
    @State private var showingCreateCollection = false
    var isScrolledPast: Bool // 添加滚动状态属性
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                Text(isScrolledPast ? "Found alphabet in" : "Unfound alphabet in")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            
            Menu {
                ForEach(photoCollections) { collection in
                    Button(collection.name) {
                        selectedCollectionId = collection.id
                    }
                }
                
                Divider()
                
                Button(action: {
                    showingCreateCollection = true
                }) {
                    Label("创建新集合", systemImage: "plus.circle")
                }
            } label: {
                HStack {
                    Text(photoCollections.first(where: { $0.id == selectedCollectionId })?.name ?? "Select Collection")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20))
                }
            }
        }
        .sheet(isPresented: $showingCreateCollection) {
            CreateCollectionView()
        }
    }
}

struct ProgressBar: View {
    var currentCollection: PhotoCollection?
    
    private var progress: Double {
        currentCollection?.progress ?? 0
    }
    
    private var progressText: String {
        let collectedCount = currentCollection?.collectedLetters.count ?? 0
        return "\(collectedCount)/26"
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            // 进度文本
            Text(progressText)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            // 进度条
            ProgressView(value: progress)
                .tint(.black)       // 设置进度条颜色
                .background(Color.gray.opacity(0.2))  // 设置背景色
                .frame(width: 100, height: 4)   // 设置固定宽度和高度
                .clipShape(Rectangle())  // 设置形状
        }
        .padding(.horizontal)
    }
}

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

struct SlidingCards: View {
    var photoItems: [PhotoItem]
    var currentCollection: PhotoCollection?
    var uncollectedLetters: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 40) {
                ForEach(uncollectedLetters, id: \.self) { letter in // 使用字母本身作为 id
                    Card(
                        title: letter,
                        description: "This is the letter \(letter)",
                        photoItems: photoItems,
                        currentCollection: currentCollection
                    )
                    .scrollTransition(.animated) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.8)
                            .scaleEffect(phase.isIdentity ? 1 : 0.9)
                    }
                }
                .frame(width: 337-40)
            }
            .scrollTargetLayout()
            .padding(.horizontal, 50)
        }
        .scrollTargetBehavior(.viewAligned)
    }
}
    
struct LetterGrid: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    var photoItems: [PhotoItem]  // 通过属性传递
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(letters.indices, id: \.self) { index in
                SmallCard(
                    letter: String(letters[index]),
                    photoItems: photoItems
                )
            }
        }
        .padding()
    }
}

struct SmallCard: View {
    let letter: String
    var photoItems: [PhotoItem]
    @State private var showPhotoPicker = false
    @Environment(\.modelContext) private var modelContext

    var currentCollection: PhotoCollection? {
        photoItems.first?.collection
    }
    
    var body: some View {
        Group {
            if let latestItem = photoItems
                .filter({ $0.letter == letter })
                .sorted(by: { $0.timestamp > $1.timestamp })
                .first,
               let uiImage = UIImage(data: latestItem.imageData) {
                // 有照片的情况
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .background(Color.gray) // 使用纯色背景
                    .cornerRadius(10)
                    .contextMenu {
                        Button(action: {
                            showPhotoPicker = true
                        }) {
                            Label("更换照片", systemImage: "photo")
                        }
                        
                        NavigationLink(destination: ViewfinderView(selectedLetter: letter, currentCollection: currentCollection)) {
                            Label("拍摄新照片", systemImage: "camera.fill")
                        }
                    }
            } else {
                // 没有照片的情况
                VStack {
                    Image("smallcardbg") // 使用背景图片
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 132)
                        .cornerRadius(10)
                    
                    Text(letter.uppercased() + letter.lowercased()) // 显示小写字母
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .padding(.top, 4)
                        .padding(.leading, 5)
                        .padding(.trailing, 58)
                }
            }
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: Binding(
                get: { nil },
                set: { newItem in
                    if let newItem {
                        loadImage(from: newItem)
                    }
                }
            ),
            matching: .images
        )
    }
    
    // 加载选中的照片
    private func loadImage(from item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let currentCollection {
                await MainActor.run {
                    let photo = PhotoItem(
                        letter: letter,
                        imageData: data,
                        collection: currentCollection
                    )
                    modelContext.insert(photo)
                }
            }
        }
    }
}

// 创建新集合的视图
struct CreateCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var collectionName: String = ""
    @State private var isTimeLimited: Bool = false // 控制时间限制的状态
    @State private var endDate: Date = Date() // 默认结束时间为当前时间

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Collection Name")) {
                    TextField("Enter collection name", text: $collectionName)
                }
                
                Section {
                    Toggle("Time Limited", isOn: $isTimeLimited)
                    
                    if isTimeLimited {
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    }
                }
                
                Button("Create") {
                    let tempCollection = PhotoCollection(name: collectionName, expectedEndDate: endDate)
                    modelContext.insert(tempCollection)
                    print("new collection has created")
                    dismiss()
                }
            }
            .navigationTitle("New Collection")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}

#Preview {
    Current_challenge()
        .modelContainer(SampleData.previewContainer)
}
