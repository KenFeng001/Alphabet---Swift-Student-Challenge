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
    
    // Computed property to get main and small photos
    private var photos: (main: PhotoItem?, small: [PhotoItem]) {
        let allPhotos = photoCollection.photos
            .sorted { $0.timestamp > $1.timestamp } // Sort by time, newest first
        
        return (
            main: allPhotos.first, // Newest photo as main photo
            small: Array(allPhotos.dropFirst().prefix(2)) // Next 2 photos as small photos
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Only show image area when photos exist
            if !photoCollection.photos.isEmpty {
                GeometryReader { geometry in
                    HStack(spacing: 8) {
                        // Main image
                        if let mainPhoto = photos.main,
                           let uiImage = UIImage(data: mainPhoto.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.6, 
                                      height: UIDevice.current.userInterfaceIdiom == .pad ? 375 : 250) // 250 * 1.5 = 375
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: geometry.size.width * 0.6)
                        }
                        
                        // Right side small images
                        if !photos.small.isEmpty {
                            VStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8) { // Spacing also increased proportionally
                                ForEach(photos.small, id: \.id) { photo in
                                    if let uiImage = UIImage(data: photo.imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width * 0.4 - 8, 
                                                   height: (UIDevice.current.userInterfaceIdiom == .pad ? (375-12) : 250 - 12) / 2)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                                
                                // Fill placeholder
                                ForEach(0..<(2 - photos.small.count), id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: geometry.size.width * 0.4 - 8, 
                                               height: (UIDevice.current.userInterfaceIdiom == .pad ? 375 : 250 - 8) / 2)
                                }
                            }
                        }
                    }
                }
                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 375 : 250)            }
            
            // Collection name and progress
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

