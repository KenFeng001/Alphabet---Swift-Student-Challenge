//
//  AlphabetApp.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI
import SwiftData

@main
struct AlphabetApp: App {
    @State private var showError = false
    @State private var errorMessage = ""
    let container: ModelContainer?

    init() {
        // Initialize as optional value
        container = try? ModelContainer(for: PhotoItem.self, PhotoCollection.self)
        
        if container == nil {
            // If initialization fails, log error but don't crash immediately
            print("Warning: ModelContainer initialization failed")
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if let container = container {
                    ContentView()
                        .modelContainer(container)
                        .task {
                            // Move first launch check here
                            if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                                createStarterCollectionIfNeeded()
                                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                            }
                        }
                } else {
                    // Show error view
                    ErrorView(message: "Data initialization failed. Please restart the app or contact support.")
                }
            }
        }
    }
    
    private func createStarterCollectionIfNeeded() {
        Task { @MainActor in
            do {
                let context = container!.mainContext
                let descriptor = FetchDescriptor<PhotoCollection>()
                let existingCollections = try context.fetch(descriptor)
                
                // If no collections exist, import sample data
                if existingCollections.isEmpty {
                    // Import data from SampleData0
                    let starterCollection = SampleData0.collection
                    context.insert(starterCollection)
                    
                    // Import data from SampleData
                    let sampleCollection = SampleData.collection
                    context.insert(sampleCollection)
                    
                    for photo in SampleData.photos {
                        context.insert(photo)
                    }
                    
                    // Import data from SampleData2
                    let sampleCollection2 = SampleData2.collection
                    context.insert(sampleCollection2)
                    
                    for photo in SampleData2.photos {
                        context.insert(photo)
                    }
                    
                    try context.save()
                    print("Successfully imported all sample data")
                }
            } catch {
                print("Failed to create or import Collection: \(error)")
            }
        }
    }
}

// Add a simple error view
struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
