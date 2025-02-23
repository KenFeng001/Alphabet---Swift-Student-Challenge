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
        // 初始化为可选值
        container = try? ModelContainer(for: PhotoItem.self, PhotoCollection.self)
        
        if container == nil {
            // 如果初始化失败，记录错误但不立即崩溃
            print("警告: ModelContainer 初始化失败")
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if let container = container {
                    ContentView()
                        .modelContainer(container)
                        .task {
                            // 将首次启动检查移到这里
                            if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                                createStarterCollectionIfNeeded()
                                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                            }
                        }
                } else {
                    // 显示错误视图
                    ErrorView(message: "数据初始化失败，请重启应用或联系支持。")
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

// 添加一个简单的错误视图
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
