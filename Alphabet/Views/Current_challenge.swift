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
    @State private var selectedCollectionId: UUID? // 新增：跟踪当前选中的collection
    
    // 获取当前选中的collection
    var currentCollection: PhotoCollection? {
        photoCollections.first { $0.id == selectedCollectionId } ?? photoCollections.first
    }
    
    // 获取当前collection的照片
    private var currentPhotos: [PhotoItem] {
        currentCollection?.photos ?? []
    }
    
    var body: some View {
        ScrollView {
            if photoCollections.isEmpty {
                // 当没有 collection 时显示的视图
                VStack {
                    Text("No Collections")
                        .font(.title)
                        .padding()
                    
                    Button(action: {
                        showingCreateCollection = true
                    }) {
                        Text("Create New Collection")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                VStack(spacing: 38){
                Navigation()
                
                VStack(spacing: 20){
                // 使用当前collection的进度
                HStack {
                    HeadLine()
                    Spacer()
                    ProgressBar(currentCollection: currentCollection)
                }
                .padding(.leading)
                
                // 传入当前collection的照片
                SlidingCards(photoItems: currentPhotos)
                    .frame(height: 461)
                }
                
                // 传入当前collection的照片
                LetterGrid(photoItems: currentPhotos)
            }
            }
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
    @State private var showLocationPicker = false
    @State private var selectedLocation = "The tube"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                Text("Finding alphabet in")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            
            Menu {
                Button("The tube") {
                    selectedLocation = "The tube"
                }
                Button("Street") {
                    selectedLocation = "Street"
                }
                // 添加更多选项
            } label: {
                HStack {
                    Text(selectedLocation)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20))
                }
            }
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
    @State private var isLetterVisible = false
    @State private var isBackdropVisible = false
    @State private var isTextVisible = false
    @State private var randomQuote: MotivationalQuote // 添加随机引用状态
    
    init(title: String, description: String, photoItems: [PhotoItem]) {
        self.title = title
        self.description = description
        self.photoItems = photoItems
        // 在初始化时选择随机引用
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
                        Button(action: {
                            // 处理按钮的点击事件
                        }) {
                            Image("takeimage")
                        }
                        Button(action: {
                            // 处理按钮的点击事件
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
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    var photoItems: [PhotoItem]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(letters.indices, id: \.self) { index in
                    Card(
                        title: String(letters[index]),
                        description: "This is the letter \(letters[index]).",
                        photoItems: photoItems
                    )
                    .frame(width: UIScreen.main.bounds.width - 80)  // 设置卡片宽度，让两边能看到其他卡片
                }
            }
            .padding(.horizontal, 40)  // 添加水平内边距
        }
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

    // 获取当前 collection
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
                // 有最新照片的情况
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .background(Color.gray)
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
                Button(action: {
                    showPhotoPicker = true
                }) {
                    VStack {
                        Text(letter)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
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
