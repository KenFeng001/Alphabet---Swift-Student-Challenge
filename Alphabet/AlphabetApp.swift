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
            do {
                let context = container.mainContext
                let descriptor = FetchDescriptor<PhotoCollection>()
                let existingCollections = try context.fetch(descriptor)
                
                // 如果没有任何 collection，导入示例数据
                if existingCollections.isEmpty {
                    // 导入 SampleData 中的 collection
                    let sampleCollection = SampleData.collection
                    context.insert(sampleCollection)
                    
                    // 导入示例照片
                    for photo in SampleData.photos {
                        context.insert(photo)
                    }
                    
                    try context.save()
                    print("成功导入示例数据")
                }
            } catch {
                print("创建或导入 Collection 失败: \(error)")
            }
        }
    }
}
