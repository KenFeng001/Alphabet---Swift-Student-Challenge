//
//  CollectionDetailView.swift
//  Alphabet
//
//  Created by Zile Feng on 22/02/2025.
//

import SwiftUI
import SwiftData

struct CollectionDetailView: View {
    var displayedCollection: PhotoCollection
    @State private var sortBy: SortOption = .time
    @State private var isStacked: Bool = true
    @State private var showUnfinished: Bool = true
    
    enum SortOption {
        case time
        case alphabet
    }
    
    var body: some View {
        ScrollView {

        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(displayedCollection.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // 返回操作
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
}

#Preview {
    NavigationStack {
        CollectionDetailView(displayedCollection: SampleData.collection)
    }
    .modelContainer(SampleData.previewContainer)
}

