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
                HStack {
                    Menu {
                        ForEach(photoCollections, id: \.id) { collection in
                            Button(action: {
                                selectedCollectionId = collection.id
                            }) {
                                Text(collection.name)
                            }
                        }
                        Button(action: {
                            showingCreateCollection = true
                        }) {
                            Text("Create New Collection")
                        }
                    } label: {
                        Text(currentCollection?.name ?? "Select Collection")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // 修改相机按钮，传入当前collection
                    NavigationLink(destination: ViewfinderView(selectedLetter: "A", currentCollection: currentCollection)) {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Circle().fill(Color.blue.opacity(0.2)))
                    }
                    .padding(.trailing)
                }
                .padding(.leading)
                
                // 使用当前collection的进度
                HStack {
                    Text("Progress")
                        .font(.headline)
                        .padding(.trailing)
                    
                    ProgressView(value: currentCollection?.progress ?? 0, total: 1)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(width: 200)
                }
                .padding(.leading)
                
                // 传入当前collection的照片
                SlidingCards(photoItems: currentPhotos)
                    .frame(height: 550)
                
                // 传入当前collection的照片
                LetterGrid(photoItems: currentPhotos)
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
    
    
struct Card: View {
    var title: String
    var description: String
    var photoItems: [PhotoItem]

    var body: some View {
        if let latestItem = photoItems
            .filter({ $0.letter == title })
            .sorted(by: { $0.timestamp > $1.timestamp })
            .first,
           let uiImage = UIImage(data: latestItem.imageData) {
            // 有最新照片的情况
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 337, height: 449)
                .clipped()
                .background(Color.gray)
                .cornerRadius(20)
                .shadow(radius: 10)
        } else {
            VStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Text(description)
                    .font(.body)
                    .padding()
            }
            .frame(width: 337, height: 449)
            .background(Color.gray)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

        
struct SlidingCards: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    var photoItems: [PhotoItem]  // 通过属性传递
    
    var body: some View {
        TabView {
            ForEach(letters.indices, id: \.self) { index in
                Card(
                    title: String(letters[index]),
                    description: "This is the letter \(letters[index]).",
                    photoItems: photoItems
                )
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // 显示页码指示器
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
    @State private var showPhotoGallery = false // 新增：控制照片集查看
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
                // 有照片的情况
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .onTapGesture {
                        showPhotoGallery = true
                    }
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
                    .sheet(isPresented: $showPhotoGallery) {
                        PhotoGalleryView(photos: letterPhotos, letter: letter)
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

struct PhotoGalleryView: View {
    var photos: [PhotoItem]
    var letter: String
    @Environment(\.modelContext) private var modelContext

    
    var body: some View {
        Text("Photo Gallery for \(letter)")


#Preview {
    Current_challenge()
        .modelContainer(SampleData.previewContainer)
}
