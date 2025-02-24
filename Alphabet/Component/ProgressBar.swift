import SwiftUI
import SwiftData

struct ProgressBar: View {
    var currentCollection: PhotoCollection?
    @Query private var photoCollections: [PhotoCollection]
    
    private var progress: Double {
        let updatedCollection = photoCollections.first { $0.id == currentCollection?.id }
        return updatedCollection?.progress ?? currentCollection?.progress ?? 0
    }
    
    private var progressText: String {
        let updatedCollection = photoCollections.first { $0.id == currentCollection?.id }
        let collectedCount = updatedCollection?.collectedLetters.count ?? currentCollection?.collectedLetters.count ?? 0
        return "\(collectedCount)/26"
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(progressText)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            ProgressView(value: progress)
                .tint(.black)
                .background(Color.gray.opacity(0.2))
                .frame(width: 100, height: 4)
                .clipShape(Rectangle())
        }
        .padding(.horizontal)
    }
} 
