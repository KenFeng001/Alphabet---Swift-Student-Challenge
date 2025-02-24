import SwiftUI
import PhotosUI

struct FinishedCards: View {
    var currentCollection: PhotoCollection
    @State private var showShareSheet = false
    @State private var showingSaveAlert = false
    @State private var exportImage: UIImage?
    @State private var showingPreview = false
    
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
                    
                    Text("You have found all the letters!")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                
                HStack {
                    Button {
                        // 创建导出图片
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
        .sheet(isPresented: $showingPreview) {
            if let image = exportImage {
                NavigationStack {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                        
                        Button("保存到相册") {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            showingPreview = false
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                    .navigationTitle("预览")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("关闭") {
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
