import CoreData
import SwiftUI
import SwiftData


@Model
class PhotoItem {
    var id: UUID
    var letter: String
    var imageData: Data
    var timestamp: Date
    var collection: PhotoCollection?
    var isPinned: Bool
    
    init(letter: String, imageData: Data, collection: PhotoCollection? = nil, isPinned: Bool = false) {
        self.id = UUID()
        self.letter = letter
        self.imageData = imageData
        self.timestamp = Date()
        self.collection = collection
        self.isPinned = isPinned
    }
}

@Model
class PhotoCollection {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var photos: [PhotoItem]
    @Relationship(inverse: \PhotoItem.collection)
    var createdAt: Date
    var expectedEndDate: Date
    var isCompleted: Bool
    
    init(name: String, expectedEndDate: Date) {
        self.id = UUID()
        self.name = name
        self.photos = []
        self.createdAt = Date()
        self.expectedEndDate = expectedEndDate
        self.isCompleted = false
    }
    
    // 获取已收集的唯一字母集合
    var collectedLetters: Set<String> {
        Set(photos.map { $0.letter })
    }
    
    // 计算进度（基于唯一字母数量）
    var progress: Double {
        return Double(collectedLetters.count) / 26.0
    }
    
    // 检查特定字母是否已收集
    func hasCollected(letter: String) -> Bool {
        return collectedLetters.contains(letter)
    }
    
    var remainingTime: TimeInterval {
        return expectedEndDate.timeIntervalSince(Date())
    }
    
    // 获取最新的照片
    var latestPhoto: PhotoItem? {
        photos.sorted(by: { $0.timestamp > $1.timestamp }).first
    }
    
    // 获取未收集的字母集合，保持字母顺序
    var uncollectedLetters: [String] {
        let allLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init)
        let collectedSet = Set(collectedLetters)
        return allLetters.filter { !collectedSet.contains($0) }
   }
    
    // 固定特定字母的 PhotoItem
    func pinPhotoItem(for letter: String, photoItem: PhotoItem) {
        // 先取消其他同字母的固定状态
        for item in photos where item.letter == letter {
            item.isPinned = false
        }
        // 设置当前 PhotoItem 为固定状态
        photoItem.isPinned = true
    }
}
