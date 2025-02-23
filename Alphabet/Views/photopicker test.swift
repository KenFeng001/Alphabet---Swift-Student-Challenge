//
//  photopicker test.swift
//  Alphabet
//
//  Created by Zile Feng on 10/02/2025.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedItem: PhotosPickerItem?
    let letter: String
    var currentCollection: PhotoCollection?
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            VStack {
                Image(systemName: "photo.fill")
                    .font(.system(size: 30))
                Text("选择照片")
                    .font(.caption)
            }
            .foregroundColor(.blue)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    let photoItem = PhotoItem(
                        letter: letter,
                        imageData: data,
                        collection: currentCollection
                    )
                    modelContext.insert(photoItem)
                }
                selectedItem = nil
            }
        }
    }
}

#Preview {
    PhotoPickerView(letter: "A", currentCollection: nil)
}

