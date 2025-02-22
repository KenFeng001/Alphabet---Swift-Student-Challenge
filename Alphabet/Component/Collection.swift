//
//  Collection.swift
//  Alphabet
//
//  Created by Zile Feng on 22/02/2025.
//

import SwiftUI
import SwiftData

struct Collection: View {
    var photoCollection: PhotoCollection
    @State private var previewPhotos: [PhotoItem] = []
    
    private var mainPhoto: PhotoItem? {
        previewPhotos.first
    }
    
    private var smallPhotos: [PhotoItem] {
        Array(previewPhotos.dropFirst().prefix(2))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 照片布局
            HStack(spacing: 8) {
                // 主图 - 始终显示第一张照片或占位符
                if let mainPhoto = mainPhoto,
                   let uiImage = UIImage(data: mainPhoto.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200, height: 200)
                }
                
                // 右侧小图 - 只在有额外照片时显示
                if !previewPhotos.isEmpty {
                    VStack(spacing: 8) {
                        ForEach(smallPhotos, id: \.id) { photo in
                            if let uiImage = UIImage(data: photo.imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 96, height: 96)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        // 补充占位符直到2个位置
                        ForEach(0..<(2 - smallPhotos.count), id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 96, height: 96)
                        }
                    }
                }
            }
            
            // 集合名称和进度
            VStack(alignment: .leading, spacing: 4) {
                Text(photoCollection.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("\(photoCollection.collectedLetters.count)/26")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 4)
        }
        .onAppear {
            // 在视图出现时随机选择照片
            previewPhotos = Array(Set(photoCollection.photos))
                .shuffled()
                .prefix(3)
                .sorted { $0.timestamp > $1.timestamp }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Collection(photoCollection: SampleData.collection)
}
