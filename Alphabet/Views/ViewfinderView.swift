////  ViewfinderView.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI

struct ViewfinderView: View {
    @StateObject var model = DataModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var selectedLetter: String
    var currentCollection: PhotoCollection?
    @State private var zoomText: String = "1x"  // Add state variable
    
    var body: some View {
        NavigationStack {
            VStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 45 : 30) {  // 30 * 1.5 = 45
                // Top current selected letter display
                Text("\(selectedLetter);\(selectedLetter.lowercased())")
                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 72 : 48))  // Font size increased by 1.5x for iPad
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40)  // Padding increased by 1.5x for iPad
                    .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40)  // Top padding increased by 1.5x for iPad
                
                // Camera preview
                if let image = model.viewfinderImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(3/4, contentMode: .fit)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                } else {
                    Color.gray
                        .aspectRatio(3/4, contentMode: .fit)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                }
                
                letterSelector
                
                // Bottom control bar
                HStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 45 : 30) {  // 30 * 1.5 = 45
                    // Back button
                    Button(action: {
                        dismiss()
                    }) {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 90 : 60,  // 60 * 1.5 = 90
                                   height: UIDevice.current.userInterfaceIdiom == .pad ? 90 : 60)
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 30 : 20))  // 20 * 1.5 = 30
                                    .foregroundColor(.white)
                            )
                    }
                    
                    // Shutter button
                    Button(action: {
                        Task { @MainActor in
                            model.camera.takePhoto()
                        }
                    }) {
                        Circle()
                            .stroke(Color.white, lineWidth: UIDevice.current.userInterfaceIdiom == .pad ? 4.5 : 3)  // 3 * 1.5 = 4.5
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 105 : 70,  // 70 * 1.5 = 105
                                   height: UIDevice.current.userInterfaceIdiom == .pad ? 105 : 70)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    .background(navigationLink)
                    
                    // Zoom button
                    Button(action: {
                        model.camera.toggleZoom()
                        zoomText = model.camera.zoomDescription
                    }) {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 90 : 60,  // 60 * 1.5 = 90
                                   height: UIDevice.current.userInterfaceIdiom == .pad ? 90 : 60)
                            .overlay(
                                Text(zoomText)
                                    .foregroundColor(.white)
                                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 16))  // 16 * 1.5 = 24
                                    .fontWeight(.medium)
                            )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
        .task {
            await model.camera.start()
        }
        .navigationBarHidden(true)
    }
    
    // Letter selector view
    private var letterSelector: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init), id: \.self) { letter in
                        letterButton(letter)
                            .id(letter)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width / 2 - 25)
            }
            .frame(height: 50)
            .background(Color.clear)
            .onChange(of: selectedLetter) { newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
    // Letter button view
    private func letterButton(_ letter: String) -> some View {
        Button(action: {
            selectedLetter = letter
        }) {
            Text(letter)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(selectedLetter == letter ? .white : .gray)
                .frame(width: 35, height: 35)
                .background(
                    Circle()
                        .fill(selectedLetter == letter ? Color.white.opacity(0.3) : Color.clear)
                )
        }
    }
    
    // Extract shutter button and navigation link as separate views
    private var shutterButton: some View {
        Button(action: {
            Task { @MainActor in
                model.camera.takePhoto()
            }
        }) {
            Circle()
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 65, height: 65)
                .background(Circle().fill(Color.white.opacity(0.2)))
                .padding(.bottom, 30)
                .padding(.top, 10)
        }
        .background(navigationLink)
    }
    
    // Extract navigation link as separate view
    private var navigationLink: some View {
        NavigationLink(
            destination: ViewfinderImagePreview(
                thumbNailImage: model.thumbnailImage ?? Image(systemName: "photo"),
                imageData: model.imageData,
                selectedLetter: selectedLetter,
                currentCollection: currentCollection
            ),
            isActive: $model.navigateToPreview
        ) {
            EmptyView()
        }
    }
}

#Preview {
    ViewfinderView(selectedLetter: "A")
}

