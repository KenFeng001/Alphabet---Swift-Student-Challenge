import SwiftUI
import PhotosUI

struct FinishedCards: View {
    var currentCollection: PhotoCollection
    @State private var showShareSheet = false
    @State private var showingSaveAlert = false
    @State private var exportImage: UIImage?
    @State private var showingPreview = false
    @State private var showCelebration = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            Image("CongratulationsBG")
                .resizable()
                .scaledToFill()
                .frame(width: 337, height: 449)
            
            VStack(spacing: 0) {
                VStack {
                    Image("CongratulationIcon")
                    
                    Text("Congratulations")
                        .font(.system(size: 24))
                }
                
                ZStack {
                    Image("Celebration")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .scaleEffect(showCelebration ? 1 : 0.5)
                        .rotationEffect(.degrees(showCelebration ? 0 : -180))
                        .opacity(showCelebration ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0), value: showCelebration)
                    
                    Text("You have found all the letters!")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .scaleEffect(showText ? 1 : 0.5)
                        .opacity(showText ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0).delay(0.3), value: showText)
                }
                
                HStack {
                    Button {
                        // Create export image
                        let exportView = ExportGrid(collection: currentCollection)
                            .frame(width: UIScreen.main.bounds.width)
                            .background(Color.white)
                        
                        let renderer = ImageRenderer(content: exportView)
                        renderer.scale = UIScreen.main.scale
                        
                        if let image = renderer.uiImage {
                            exportImage = image
                            showingPreview = true
                        }
                    } label: {
                        Image("share")
                    }
                }
                .padding(.leading, 140)
                .padding(.top, 30)
            }
        }
        .frame(width: 349, height: 461)
        .clipped()
        .cornerRadius(20)
        .onAppear {
            showCelebration = true
            showText = true
        }
        .sheet(isPresented: $showingPreview) {
            if let image = exportImage {
                NavigationStack {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                        
                        Button("Save to Photos") {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            showingPreview = false
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                    .navigationTitle("Preview")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Close") {
                                showingPreview = false
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FinishedCards(currentCollection: SampleData.collection)
}
