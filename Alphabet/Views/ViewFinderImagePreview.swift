import SwiftUI
import SwiftData

struct ViewfinderImagePreview: View {
    @Environment(\.dismiss) private var dismiss // Environment variable for returning
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    var thumbNailImage: Image
    var imageData: Data // Receives Image type data
    var selectedLetter: String // Receives letter data
    var currentCollection: PhotoCollection? // New parameter
    
    var body: some View {
        VStack(spacing: 0) {
            // Top letter display
            Text("\(selectedLetter);\(selectedLetter.lowercased())")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 40)
            
            // Image preview
            thumbNailImage
                .resizable()
                .scaledToFill()
                .aspectRatio(3/4, contentMode: .fit)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            // Bottom control bar
            HStack {
                // Back button
                Button(action: {
                    dismiss()
                }) {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        )
                }
                
                Spacer()
                
                // Save button
                Button(action: {
                    saveImage()
                    // Close all pages and return to Current_challenge
                    dismiss()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Saved to \(selectedLetter)")
                        .font(Font.custom("SF Pro", size: 22))
                        .foregroundColor(.white)
                        .padding(.horizontal, 61)
                        .padding(.vertical, 21)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(22)
                        .multilineTextAlignment(.center)

                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
    }

    // Function to save image
    private func saveImage() {
        // Save to App
        let photoItem = PhotoItem(
            letter: selectedLetter, 
            imageData: imageData,
            collection: currentCollection
        )
        modelContext.insert(photoItem)
        currentCollection?.pinPhotoItem(for: selectedLetter, photoItem: photoItem)
        
        // Save to system photo album
        if let uiImage = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        }
        
        print("Saving image with letter: \(selectedLetter) to collection: \(currentCollection?.name ?? "none")")
    }
}

// Add Image extension to support conversion to UIImage
extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// Add preview
#Preview {
    ViewfinderImagePreview(
        thumbNailImage: Image("Y"),
        imageData: Data(), // Use empty Data for preview
        selectedLetter: "A",
        currentCollection: nil
    )
}
