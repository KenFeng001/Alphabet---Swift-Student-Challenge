import SwiftUI
import SwiftData

struct SampleData {
    static let collection = PhotoCollection(
        name: "TFL Wander",
        expectedEndDate: Date().addingTimeInterval(30 * 24 * 3600)
    )
    
    static let photos = [
        PhotoItem(letter: "A", imageData: UIImage(named: "A_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "B", imageData: UIImage(named: "B_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "D", imageData: UIImage(named: "D_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "H", imageData: UIImage(named: "H_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "I", imageData: UIImage(named: "IMG_6239")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "L", imageData: UIImage(named: "L_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "M", imageData: UIImage(named: "M_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "T", imageData: UIImage(named: "T_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "V", imageData: UIImage(named: "V_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "W", imageData: UIImage(named: "W_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "X", imageData: UIImage(named: "X_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "Y", imageData: UIImage(named: "Y_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection),
        PhotoItem(letter: "Z", imageData: UIImage(named: "Z_TFL")?.jpegData(compressionQuality: 0.8) ?? Data(), collection: collection)
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

struct SampleData2 {
    static let collection = PhotoCollection(
        name: "Colors",
        expectedEndDate: Date().addingTimeInterval(30 * 24 * 3600)
    )
    
    static let photos: [PhotoItem] = {
        let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return letters.enumerated().map { index, letter in
            let imageName = "Sample\(index + 1)"
            return PhotoItem(
                letter: String(letter),
                imageData: UIImage(named: imageName)?.jpegData(compressionQuality: 0.8) ?? Data(),
                collection: collection,
                isPinned: false
            )
        }
    }()
    
    @MainActor
    static var previewContainer: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: PhotoItem.self, PhotoCollection.self, configurations: config)
        container.mainContext.insert(collection)
        photos.forEach { container.mainContext.insert($0) }
        return container
    }()
}
