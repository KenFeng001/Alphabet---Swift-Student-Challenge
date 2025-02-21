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
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: PhotoItem.self, PhotoCollection.self)
            // 只在首次启动时检查并创建 Starter Collection
            if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                createStarterCollectionIfNeeded()
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            }
        } catch {
            fatalError("Failed to initialize ModelContainer")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
         }
        .modelContainer(container)

    }
    
    private func createStarterCollectionIfNeeded() {
        Task { @MainActor in
            let context = container.mainContext
            // 检查是否存在任何 Collection
            let descriptor = FetchDescriptor<PhotoCollection>()
            let existingCollections = try? context.fetch(descriptor)
            
            // 只在没有任何 collection 时创建 Starter Collection
            if existingCollections?.isEmpty ?? true {
                let starterCollection = PhotoCollection(
                    name: "Starter",
                    expectedEndDate: Date().addingTimeInterval(30 * 24 * 60 * 60)
                )
                context.insert(starterCollection)
                try? context.save()
            }
        }
    }
}
