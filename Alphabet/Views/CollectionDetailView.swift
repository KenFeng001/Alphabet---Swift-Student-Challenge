//
//  CollectionDetailView.swift
//  Alphabet
//
//  Created by Zile Feng on 22/02/2025.
//

import SwiftUI
import SwiftData

struct CollectionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var displayedCollection: PhotoCollection
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 内容区域
                VStack(alignment: .leading, spacing: 20) {
                    // 集合信息
                    Text(displayedCollection.name)
                        .font(.system(size: 32, weight: .bold))
                    
                    // 这里可以添加更多集合详情内容
                    
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // 添加更多操作
                }) {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

#Preview {
    CollectionDetailView(displayedCollection: SampleData.collection)
        .modelContainer(SampleData.previewContainer)
}
