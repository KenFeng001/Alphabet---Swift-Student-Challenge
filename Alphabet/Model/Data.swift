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
    
    // Get collected unique letter set
    var collectedLetters: Set<String> {
        Set(photos.map { $0.letter })
    }
    
    // Calculate progress (based on unique letter count)
    var progress: Double {
        return Double(collectedLetters.count) / 26.0
    }
    
    // Check if specific letter has been collected
    func hasCollected(letter: String) -> Bool {
        return collectedLetters.contains(letter)
    }
    
    var remainingTime: TimeInterval {
        return expectedEndDate.timeIntervalSince(Date())
    }
    
    // Get latest photo
    var latestPhoto: PhotoItem? {
        photos.sorted(by: { $0.timestamp > $1.timestamp }).first
    }
    
    // Get uncollected letter set, maintain alphabetical order
    var uncollectedLetters: [String] {
        let allLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init)
        let collectedSet = Set(collectedLetters)
        return allLetters.filter { !collectedSet.contains($0) }
   }
    
    // Pin PhotoItem for specific letter
    func pinPhotoItem(for letter: String, photoItem: PhotoItem) {
        // First cancel pinned status for other photos of same letter
        for item in photos where item.letter == letter {
            item.isPinned = false
        }
        // Set current PhotoItem as pinned
        photoItem.isPinned = true
    }
}
