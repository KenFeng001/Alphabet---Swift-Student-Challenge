import SwiftUI
import SwiftData

struct SampleData {
    static let collection = PhotoCollection(
        name: "TFL Wander",
        expectedEndDate: Date().addingTimeInterval(30 * 24 * 3600)
    )
    
    static let photos = [
        PhotoItem(letter: "B", imageData: UIImage(named: "B")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "H", imageData: UIImage(named: "H")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "Y", imageData: UIImage(named: "Y")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection)
    ]
    
    @MainActor
    static var previewContainer: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: PhotoItem.self, PhotoCollection.self, configurations: config)
        container.mainContext.insert(collection)
        photos.forEach { container.mainContext.insert($0) }
        return container
    }()
} 
