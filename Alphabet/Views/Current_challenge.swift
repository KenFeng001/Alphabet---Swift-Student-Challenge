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
    @State private var selectedCollectionId: UUID? = SampleData.collection.id  // 设置默认的示例集合 ID
    @State private var scrollProgress: CGFloat = 0.0 // 添加滚动进度状态
    @State private var showingImagePreview = false
    @State private var selectedPreviewPhotos: [PhotoItem] = []
    @State private var selectedPreviewLetter: String = ""
    
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
                    
                    LetterGrid(
                        photoItems: currentPhotos,
                        showingImagePreview: $showingImagePreview,
                        selectedPreviewPhotos: $selectedPreviewPhotos,
                        selectedPreviewLetter: $selectedPreviewLetter
                    )
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
        .blur(radius: showingImagePreview ? 3 : 0) // 添加模糊效果
        .overlay {
            if showingImagePreview {
                ImagePreviewer(
                    photos: selectedPreviewPhotos,
                    selectedLetter: selectedPreviewLetter,
                    isPresented: $showingImagePreview
                )
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
