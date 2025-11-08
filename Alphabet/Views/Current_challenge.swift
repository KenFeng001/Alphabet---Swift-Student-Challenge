//
//  Current_challenge.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI
import SwiftData

struct Current_challenge: View {
    @Binding var selectedCollectionId: UUID?
    var currentTab: Tab
    var onTabChange: (Tab) -> Void
    
    @Query private var photoCollections: [PhotoCollection]
    @Query private var allPhotoItems: [PhotoItem]
    
    @State private var showCamera = false
    @State private var selectedCameraLetter = ""
    
    // Get currently selected collection
    private var currentCollection: PhotoCollection? {
        guard let selectedId = selectedCollectionId else { return nil }
        return photoCollections.first { $0.id == selectedId }
    }
    
    // Get photos for current collection
    private var currentCollectionPhotos: [PhotoItem] {
        guard let collection = currentCollection else { return [] }
        return allPhotoItems.filter { $0.collection?.id == collection.id }
    }
    
    // Get uncollected letters
    private var uncollectedLetters: [String] {
        currentCollection?.uncollectedLetters ?? []
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header information
                if let collection = currentCollection {
                    HeadLine(currentCollection: collection)
                }
                
                // Main content area
                ScrollView {
                    VStack(spacing: 20) {
                        // Sliding cards area
                        if let collection = currentCollection {
                            SlidingCards(
                                photoItems: currentCollectionPhotos,
                                currentCollection: collection,
                                uncollectedLetters: uncollectedLetters,
                                onCameraRequest: { letter in
                                    selectedCameraLetter = letter
                                    showCamera = true
                                }
                            )
                        }
                        
                        // Progress bar
                        if let collection = currentCollection {
                            ProgressBar(currentCollection: collection)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                
                // Bottom navigation
                Navigation(currentTab: currentTab, onTabChange: onTabChange)
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showCamera) {
                ViewfinderView(
                    selectedLetter: selectedCameraLetter,
                    currentCollection: currentCollection
                )
            }
        }
    }
}

#Preview {
    Current_challenge(
        selectedCollectionId: .constant(SampleData.collection.id),
        currentTab: .find
    ) { _ in }
    .modelContainer(SampleData.previewContainer)
}