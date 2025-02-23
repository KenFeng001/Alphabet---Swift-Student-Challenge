//
//  CollectionDetailView.swift
//  Alphabet
//
//  Created by Zile Feng on 22/02/2025.
//

import SwiftUI
import SwiftData
import Foundation  // 如果需要的话

// 如果 SortOption 在单独的模块中，需要导入该模块

struct CollectionDetailView: View {
    @Environment(\.dismiss) private var dismiss  // 添加 dismiss 环境变量
    var displayedCollection: PhotoCollection
    @State private var sortBy: SortOption = .time
    @State private var isStacked: Bool = true
    @State private var showUnfinished: Bool = true
    
    // 添加图片预览所需的状态
    @State private var showingImagePreview = false
    @State private var selectedPreviewPhotos: [PhotoItem] = []
    @State private var selectedPreviewLetter: String = ""
    
    var body: some View {
        ZStack {
            ScrollView {
                LetterGrid(
                    photoItems: displayedCollection.photos,
                    currentCollection: displayedCollection,
                    showingImagePreview: $showingImagePreview,
                    selectedPreviewPhotos: $selectedPreviewPhotos,
                    selectedPreviewLetter: $selectedPreviewLetter,
                    isStacked: isStacked,
                    showUnfinished: showUnfinished,
                    sortBy: sortBy
                )
            }
            .navigationBarBackButtonHidden(true)  // 隐藏默认的返回按钮
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(displayedCollection.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Collection")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        // 排序选项
                        Menu("Sort by") {
                            Button {
                                sortBy = .time
                            } label: {
                                HStack {
                                    Text("Time")
                                    if sortBy == .time {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            
                            Button {
                                sortBy = .alphabet
                            } label: {
                                HStack {
                                    Text("Alphabet")
                                    if sortBy == .alphabet {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                        
                        // 堆叠选项
                        Button {
                            isStacked.toggle()
                        } label: {
                            HStack {
                                Text(isStacked ? "Unstack" : "Stack")
                                if isStacked {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                        // 显示未完成选项
                        Button {
                            showUnfinished.toggle()
                        } label: {
                            HStack {
                                Text(showUnfinished ? "Hide Unfinished" : "Show Unfinished")
                                if showUnfinished {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
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
//
//#Preview {
//    NavigationStack {
//        CollectionDetailView(displayedCollection: SampleData.collection)
//    }
//    .modelContainer(SampleData.previewContainer)
//}
//
