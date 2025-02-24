//
//  CollectionDetailView.swift
//  Alphabet
//
//  Created by Zile Feng on 22/02/2025.
//

import SwiftUI
import SwiftData
import Foundation  // If needed

// If SortOption is in a separate module, need to import that module

struct CollectionDetailView: View {
    @Environment(\.dismiss) private var dismiss  // Add dismiss environment variable
    @Environment(\.modelContext) private var modelContext  // Add modelContext
    var displayedCollection: PhotoCollection
    @State private var sortBy: SortOption = .time
    @State private var isStacked: Bool = true
    @State private var showUnfinished: Bool = true
    @State private var showingDeleteAlert = false  // Add delete confirmation alert state
    
    // Add states needed for image preview
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
            .navigationBarBackButtonHidden(true)  // Hide default return button
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
                        // Sort options
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
                        
                        // Stack options
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
                        
                        // Show unfinished options
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
                        
                        Divider()  // Add separator
                        
                        // Add delete options
                        Button(role: .destructive) {  // Use destructive role to show in red
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete Collection", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .alert("Confirm Delete", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteCollection()
                }
            } message: {
                Text("Are you sure you want to delete this collection? This action cannot be undone.")
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
    
    // Add delete method
    private func deleteCollection() {
        modelContext.delete(displayedCollection)
        dismiss()  // Return to previous page after deletion
    }
}

#Preview {
    NavigationStack {
        CollectionDetailView(displayedCollection: SampleData.collection)
    }
    .modelContainer(SampleData.previewContainer)
}

