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
    @Binding var selectedCollectionId: UUID?
    var currentTab: Tab
    var onTabChange: (Tab) -> Void
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
        ZStack {
            NavigationStack {
                if photoCollections.isEmpty {
                    VStack(spacing: 0) {
                        Color.clear
                            .frame(height: 60)
                        Spacer()
                        Button(action: {
                            showingCreateCollection = true
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 60))
                                Text("创建你的第一个集合")
                                    .font(.system(size: 20, weight: .medium))
                            }
                            .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .overlay(alignment: .top) {
                        VStack(spacing: 20) {
                            Navigation(currentTab: currentTab, onTabChange: onTabChange)
                                .padding(.horizontal, 16)
                            Color.clear
                                .frame(height: 60)
                        }
                        .background {
                            Rectangle()
                                .fill(.white)
                                .opacity(0.8)
                                .blur(radius: 20)
                                .ignoresSafeArea()
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(height: 140) // Navigation + HeadLine + spacing的总高度
                            
                            SlidingCards(photoItems: currentPhotos, 
                                       currentCollection: currentCollection, 
                                       uncollectedLetters: uncollectedLetters)
                                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 691.5 : 461) // 461 * 1.5 = 691.5
                            
                            VStack {
                                Divider()
                                    .padding(.vertical, 10)
                                
                                LetterGrid(
                                    photoItems: currentPhotos,
                                    currentCollection: currentCollection,
                                    showingImagePreview: $showingImagePreview,
                                    selectedPreviewPhotos: $selectedPreviewPhotos,
                                    selectedPreviewLetter: $selectedPreviewLetter,
                                    isStacked: true,  // Current_challenge 中总是堆叠显示
                                    showUnfinished: true,  // Current_challenge 中总是显示未完成项
                                    sortBy: .alphabet  // Current_challenge 中按字母顺序排序
                                )
                            }
                        }
                        .background(GeometryReader { geo -> Color in
                            let offset = geo.frame(in: .global).minY
                            DispatchQueue.main.async {
                                scrollProgress = -offset / 100
                            }
                            return Color.clear
                        })
                    }
                    .scrollIndicators(.hidden) // 隐藏滚动条
                    .overlay(alignment: .top) {
                        VStack(spacing: 20) {
                            Navigation(currentTab: currentTab, onTabChange: onTabChange)
                                .background {
                                    Rectangle()
                                        .fill(.white)
                                        .opacity(0.8)
                                        .blur(radius: 20)
                                        .ignoresSafeArea()
                                }
                            
                            HStack {
                                HeadLine(
                                    selectedCollectionId: $selectedCollectionId,
                                    isScrolledPast: scrollProgress > 0.3
                                )
                                Spacer()
                                ProgressBar(currentCollection: currentCollection)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal, 16)
                        .background {
                            Rectangle()
                                .fill(.white)
                                .opacity(0.8)
                                .blur(radius: 20)
                                .ignoresSafeArea()
                        }
                        .overlay(alignment: .bottom) {
                            LinearGradient(
                                colors: [.white.opacity(0), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 40)
                            .offset(y: 20)
                        }
                    }
                    .navigationDestination(isPresented: $showingImagePreview) {
                        ImagePreviewer(
                            photos: selectedPreviewPhotos,
                            selectedLetter: selectedPreviewLetter,
                            isPresented: $showingImagePreview
                        )
                    }
                }
            }
            .sheet(isPresented: $showingCreateCollection) {
                CreateCollectionView { newId in
                    selectedCollectionId = newId
                }
            }
            .onChange(of: photoCollections) { oldValue, newValue in
                if selectedCollectionId == nil && !newValue.isEmpty {
                    selectedCollectionId = newValue.first?.id
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
    @State private var isTimeLimited: Bool = false
    @State private var endDate: Date = Date()
    var onCollectionCreated: (UUID) -> Void
    
    // 预设的主题建议
    let suggestedThemes = ["Travel", "Afternoon", "My Room", "Nature", "City Life", "Food"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Collection Name")) {
                    TextField("Enter collection name", text: $collectionName)
                    
                    // 主题建议
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(suggestedThemes, id: \.self) { theme in
                                Button(action: {
                                    collectionName = theme
                                }) {
                                    Text(theme)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.gray.opacity(0.2))
                                        )
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Button("Create") {
                    let tempCollection = PhotoCollection(name: collectionName, expectedEndDate: endDate)
                    modelContext.insert(tempCollection)
                    onCollectionCreated(tempCollection.id)
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
    Current_challenge(selectedCollectionId: .constant(SampleData.collection.id), currentTab: .find) { _ in }
        .modelContainer(SampleData.previewContainer)
}
