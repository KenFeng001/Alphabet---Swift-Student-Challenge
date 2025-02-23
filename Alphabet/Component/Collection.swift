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
    
    // 获取主照片和小照片的计算属性
    private var photos: (main: PhotoItem?, small: [PhotoItem]) {
        let allPhotos = photoCollection.photos
            .sorted { $0.timestamp > $1.timestamp } // 按时间排序，最新的在前
        
        return (
            main: allPhotos.first, // 最新的照片作为主照片
            small: Array(allPhotos.dropFirst().prefix(2)) // 接下来的2张作为小照片
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { geometry in
                HStack(spacing: 8) {
                    // 主图
                    if let mainPhoto = photos.main,
                       let uiImage = UIImage(data: mainPhoto.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.6, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: geometry.size.width * 0.6)
                    }
                    
                    // 右侧小图
                    if !photos.small.isEmpty {
                        VStack(spacing: 8) {
                            ForEach(photos.small, id: \.id) { photo in
                                if let uiImage = UIImage(data: photo.imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width * 0.4 - 8, height: (geometry.size.height - 8) / 2)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            
                            // 补充占位符
                            ForEach(0..<(2 - photos.small.count), id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: geometry.size.width * 0.4 - 8, height: (geometry.size.height - 8) / 2)
                            }
                        }
                    }
                }
            }
            .frame(height: 250)
            
            // 集合名称和进度
            VStack(alignment: .leading, spacing: 4) {
                Text(photoCollection.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("\(photoCollection.collectedLetters.count)/26")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.7))
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    Collection(photoCollection: SampleData.collection)
        .modelContainer(SampleData.previewContainer)
}

